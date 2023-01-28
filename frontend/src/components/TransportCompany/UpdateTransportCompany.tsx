import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import config from '../../config.json'
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
import getAllEtaps from "../../utils/adapter/getAllEtaps";
import getCertainTransportCompany from "../../utils/adapter/getCertainTransportCompany";
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
const etaps_columns = [

    {
        title: 'Punkt poczatkowy',
        key: 'punkt_poczatkowy',
        render: (text: any, record: any) => <>{record.punkt_poczatkowy}</>,
    },
    {
        title: 'Punkt konczowy',
        key: 'punkt_konczowy',
        render: (text: any, record: any) => <>{record.punkt_konczowy}</>,
    },
    {
        title: 'Koszt',
        key: 'koszt',
        render: (text: any, record: any) => <>{record.koszt}</>,
    },
    {
        title: 'Data poczatkowa',
        key: 'data_poczatkowa',
        render: (text: any, record: any) => <>{record.data_poczatkowa.split(' ')[0]}</>,
    },
    {
        title: 'Data koncowa',
        key: 'data_koncowa',
        render: (text: any, record: any) => <>{record.data_koncowa.split(' ')[0]}</>,
    },
]
const UpdateTransportCompany = () => {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false)
    const { id } = useParams()
    const [selectedEtapKeys, setSelectedEtapKeys] = useState<React.Key[]>([]);
    const onSelectEtapChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedEtapKeys(newSelectedRowKeys);
    }
    const rowEtapSelection = {
        selectedRowKeys: selectedEtapKeys,
        onChange: onSelectEtapChange,
    }
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
                    selectedEtapKeys.filter(onlyUnique).map((value: any) => {
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

    const [etapData, setEtapData] = useState();
    const [data, setData] = useState({ etapy: [] });
    useEffect(() => {
        getAllEtaps(setEtapData)
        getCertainTransportCompany(id, setData)
    }, [])

    useEffect(() => {
        form.setFieldsValue(data)
        let etapy: any = []
        data.etapy.map((value: any) => {
            etapy.push(value.id)
        })
        setSelectedEtapKeys(etapy)
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
                label="Etapy"
            >
                <Table
                    rowSelection={rowEtapSelection}
                    columns={etaps_columns}
                    dataSource={etapData}
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

