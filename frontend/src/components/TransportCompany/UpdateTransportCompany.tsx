import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import config from '../../config.json'
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
import getAllEtaps from "../../utils/adapter/getAllEtaps";
import getAllTransport from "../../utils/adapter/getAllTransport";
import getCertainTransportCompany from "../../utils/adapter/getCertainTransportCompany";
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
const UpdateTransportCompany = () => {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false)
    const { id } = useParams()

    const onFinish = (values: any) => {
        values.id = Number(id)
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };
        setLoading(true)

        fetch(config.SERVER_URL + "/api/update/certain_transport_company", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedTransportKeys.filter(onlyUnique).map((value: any) => {
                        addTransportCompanyToTransport(Number(id), value)
                    })
                    setTimeout(function () {
                        window.open('/firma_transportowa', '_self')
                    }, 2.0 * 1000);
                    message.success("Udało sie zaktualizować firme transportowa")
                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas aktualizowania, odśwież strone i spróbuj ponownie")
                }

            }).catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    const [selectedTransportKeys, setSelectedTransportKeys] = useState<React.Key[]>([]);
    const [transportData, setTransportData] = useState();
    const onSelectTransportsChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedTransportKeys(newSelectedRowKeys);

    };

    const rowTransportSelection = {
        selectedRowKeys: selectedTransportKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectTransportsChange,
    };
    const [data, setData] = useState({ transporty: [] });
    useEffect(() => {
        getAllTransport(setTransportData)
        getCertainTransportCompany(id, setData)
    }, [])
    useEffect(() => {
        form.setFieldsValue(data)
        if (data.transporty.length > 0 && data.transporty.at(-1)) {
            let transport: any = []
            data.transporty.map((value: any) => {
                transport.push(value.id)
            })
            setSelectedTransportKeys(transport)
        }
    }, [data])
    return <>
        <h2>Aktualizowanie firmy transportowej</h2>
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
                    Zaktualizuj firmę transportową

                </Button>
            </Form.Item>
        </Form>
    </>
}
export default UpdateTransportCompany

