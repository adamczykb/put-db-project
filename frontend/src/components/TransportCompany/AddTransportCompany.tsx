import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";

import config from '../../config.json'
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
import getTransportData from "../../utils/adapter/getTransportData";
import { onlyUnique } from "../Pilots/UpdatePilot";


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

const columns_transport = [
    {
        title: 'Nazwa',
        key: 'nazwa',
        render: (text: any, record: any) => <>{record.nazwa}</>,
    },
    {
        title: 'Liczba jednostek',
        key: 'liczba_jednostek',
        render: (text: any, record: any) => <>{record.liczba_jednostek}</>,
    },
    {
        title: 'Liczba miejsc',
        key: 'liczba_miejsc',
        render: (text: any, record: any) => <>{record.liczba_miejsc}</>,
    },
]
const AddTransportCompany = () => {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [selectedTransportKeys, setSelectedTransportKeys] = useState<React.Key[]>([]);
    const [transportData, setTransportData] = useState();
    const onSelectTransportsChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedTransportKeys(newSelectedRowKeys);

    };
    useEffect(() => {
        getTransportData(setTransportData)
    }, [])
    const rowTransportSelection = {
        selectedRowKeys: selectedTransportKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectTransportsChange,
    };
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
        fetch(config.SERVER_URL + "/api/push/transport_company", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedTransportKeys.filter(onlyUnique).map((value: any) => {
                        addTransportCompanyToTransport(Number(response.result), value)
                    })
                    setTimeout(function () {
                        window.open('/firma_transportowa', '_self')
                    }, 2.0 * 1000);

                    console.log(response)
                    message.success("Dodano nowa firme transportową")
                    setTimeout(function () {
                        window.open('/firma_transportowa', '_self')
                    }, 2.0 * 1000);
                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas dodawania firmy transportowej, firma o takiej nazwie juz istnieje")
                }
            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowej firmy transportowej</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item
                name="nazwa"
                label="Nazwa"
                rules={[
                    {
                        required: true,
                        message: 'Pole imię nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="telefon"
                label="Numer telefonu"
                rules={[
                    {
                        required: true,
                        message: 'Pole numer telefonu nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (!/^\+?[0-9]{10,12}$/.test(value)) {
                                return Promise.reject('Numer telefonu jest nieprawidłowy');
                            }
                            return Promise.resolve();
                        }
                    }
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="adres"
                label="Adres"
                rules={[
                    {
                        required: true,
                        message: 'Pole adres nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>

            <Form.Item
                label="Powiązany z transportami"
            >
                <Table
                    rowSelection={rowTransportSelection}
                    columns={columns_transport}
                    dataSource={transportData}
                />
            </Form.Item>



            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit" loading={loading}>
                    Dodaj firmę transportową
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddTransportCompany
