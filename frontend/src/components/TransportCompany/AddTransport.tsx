import { Button, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";

import config from '../../config.json'
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
import getTransportCompanyData from "../../utils/adapter/getTransportCompanyData";
const firma_transportowa_columns = [
    {
        title: 'Nazwa',
        key: 'nazwa',
        render: (text: any, record: any) => <>{record.nazwa}</>,
        sorter: (a: any, b: any) => a.nazwa.localeCompare(b.nazwa),
    },
    {
        title: 'Numer telefonu',
        key: 'telefon',
        render: (text: any, record: any) => <>{record.telefon}</>,
    },
    {
        title: 'Adres',
        render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
        key: 'adres',
    },
]

const tailFormItemLayout = {
    wrapperCol: {
        xs: {
            span: 24,
            offset: 0,
        },
        sm: {
            span: 16,
            offset: 8,
        },
    },
};
const formItemLayout = {
    labelCol: {
        xs: { span: 24 },
        sm: { span: 8 },
    },
    wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
    },
};
const AddTransport = () => {
    const [form] = Form.useForm();
    const [selectedFirmaKeys, setSelectedFirmaKeys] = useState<React.Key[]>([]);
    const [firmaData, setFirmaData] = useState();
    const onSelectFirmaChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedFirmaKeys(newSelectedRowKeys);
    };
    const rowFirmaSelection = {
        selectedFirmaKeys,
        onChange: onSelectFirmaChange,
    };
    useEffect(() => {
        getTransportCompanyData(setFirmaData)
    }, [])



    const [loading, setLoading] = useState(false)


    const onFinish = (values: any) => {
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };
        setLoading(true)
        fetch(config.SERVER_URL + "/api/push/transport", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedFirmaKeys.map((value: any) => {
                        addTransportCompanyToTransport(value, response.result)
                    })
                    console.log(response)
                    message.success("Dodano nowy transport")
                    setTimeout(function () {
                        window.open('/transport', '_self')
                    }, 2.0 * 1000);
                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas dodawania transportu, taki juz istnieje")
                }
            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowego transportu</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item
                label='Nazwa transportu'
                name={'nazwa'}
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwa transportu nie może być puste!',
                    },
                ]}

            >
                <Input />
            </Form.Item>
            <Form.Item
                label='Liczba jednostek'
                name={'liczba_jednostek'}
                rules={[
                    {
                        required: true,
                        message: 'Pole liczba jednostek nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value < 0) {
                                return Promise.reject('Liczba jednostek musi być dodatnia');
                            }
                            return Promise.resolve();
                        },
                    }
                ]
                }
            >
                <InputNumber />
            </Form.Item>
            <Form.Item
                label='Liczba miejsc'
                name='liczba_miejsc'
                rules={[
                    {
                        required: true,
                        message: 'Pole liczba miejsc nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value < 0) {
                                return Promise.reject('Liczba miejsc musi być dodatnia');
                            }
                            return Promise.resolve();
                        },
                    }
                ]
                }
            >
                <InputNumber />
            </Form.Item>
            <Form.Item
                label="Powiązany z firmami transportowymi"

            >
                <Table
                    rowSelection={rowFirmaSelection}
                    columns={firma_transportowa_columns}
                    dataSource={firmaData}
                />
            </Form.Item>
            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit" loading={loading}>
                    Dodaj transport
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddTransport
