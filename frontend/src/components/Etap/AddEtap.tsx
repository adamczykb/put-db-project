import { Button, DatePicker, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";

import config from '../../config.json'
import addEtapToJourney from "../../utils/adapter/addEtapToJourney";
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
import getJourneyData from "../../utils/adapter/getJourneyData";
import getTransportCompanyData from "../../utils/adapter/getTransportCompanyData";
import { stringToDate } from "../home/UpdateClient";
const { RangePicker } = DatePicker;

const rangeConfig = {
    rules: [{ type: 'array' as const, required: true, message: 'Proszę wybrać date i godzine' }],
};

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
const columns_journey = [
    {
        title: 'Nazwa',
        key: 'nazwa',
        render: (text: any, record: any) => <>{record.nazwa}</>,
        sorter: (a: any, b: any) => a.nazwa.localeCompare(b.nazwa),
    },
    {
        title: 'Cena',
        key: 'cena',
        render: (text: any, record: any) => <>{record.cena}zł</>,
        sorter: (a: any, b: any) => a.cena - b.cena,
    },
    {
        title: 'Data rozpoczecia',
        key: 'data_rozpoczecia',
        render: (text: any, record: any) => <>{record.data_rozpoczecia.split(' ')[0]}</>,
        sorter: (a: any, b: any) => stringToDate(a.data_rozpoczecia.split(' ')[0], "yyyy-mm-dd", '-').getTime() - stringToDate(b.data_rozpoczecia.split(' ')[0], "yyyy-mm-dd", '-').getTime(),
    },
    {
        title: 'Data ukonczenia',
        key: 'data_ukonczenia',
        render: (text: any, record: any) => <>{record.data_ukonczenia.split(' ')[0]}</>,
        sorter: (a: any, b: any) => stringToDate(a.data_ukonczenia.split(' ')[0], "yyyy-mm-dd", '-').getTime() - stringToDate(b.data_ukonczenia.split(' ')[0], "yyyy-mm-dd", '-').getTime(),
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
const AddEtap = () => {
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
    const [loading, setLoading] = useState(false);
    const [selectedJounrneyKeys, setSelectedJounrneyKeys] = useState<React.Key[]>([]);
    const [journeyData, setJourneyData] = useState();
    const onSelectLanguagesChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedJounrneyKeys(newSelectedRowKeys);

    };
    const rowJourneySelection = {
        selectedRowKeys: selectedJounrneyKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectLanguagesChange,
    };
    const onChange = (data: any) => {
        let sendData = {
            id_list: [],
            from: '',
            to: ''
        }

        if (data && data[0] && data[1]) {
            sendData = {
                id_list: [],
                from: data[0].format('DD-MM-YYYY'),
                to: data[1].format('DD-MM-YYYY')
            }
        }


        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: sendData })
        };

        fetch(config.SERVER_URL + "/api/get/certain_journey", requestOptions)
            .then((response) => response.json())
            .then((response) => {

                if (response.status == 200) {
                    setJourneyData(response.result)
                    setSelectedJounrneyKeys([])
                } else {
                    message.error("Wystąpił błąd podczas pobierania podróży, spróbuj ponownie")
                }

            }).then(() => {

            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    }

    useEffect(() => {
        getTransportCompanyData(setFirmaData)
        getJourneyData(setJourneyData)
        form.setFieldsValue({ koszt: 0, liczba_miejsc: 0, liczba_jednostek: 0 })
    }, [])

    const onFinish = (values: any) => {

        const transport = {
            nazwa: values.nazwa,
            liczba_jednostek: values.liczba_jednostek,
            liczba_miejsc: values.liczba_miejsc,

        }
        const out = {
            punkt_poczatkowy: values.punkt_poczatkowy,
            punkt_konczowy: values.punkt_konczowy,
            koszt: values.koszt,
            data_poczatkowa: values.data_rozpoczecia[0].format('DD-MM-YYYY'),
            data_koncowa: values.data_rozpoczecia[1].format('DD-MM-YYYY'),

            transport
        }
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: out })
        };
        setLoading(true)
        fetch(config.SERVER_URL + "/api/push/etap", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedFirmaKeys.map((value: any) => {
                        addTransportCompanyToTransport(response.result, value)
                    })
                    selectedJounrneyKeys.map((value: any) => {
                        addEtapToJourney(response.result, value)
                    })
                    message.success("Pomyślnie dodano etap")
                    setTimeout(function () {
                        window.open('/etapy', '_self')
                    }, 2.0 * 1000);
                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas dodawania etapu, spróbuj ponownie")
                }

            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowego etapu</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item
                name="punkt_poczatkowy"
                label="Punkt poczatkowy"
                rules={[
                    {
                        required: true,
                        message: 'Pole punkt poczatkowy nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="punkt_konczowy"
                label="Punkt konczowy"
                rules={[
                    {
                        required: true,
                        message: 'Pole punkt konczowy nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="koszt"
                label="Koszt (zł)"
                rules={[
                    {
                        required: true,
                        message: 'Pole adres nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value < 0) {
                                return Promise.reject('Koszt musi być dodatni');
                            }
                            return Promise.resolve();
                        },
                    }
                ]}
            >
                <InputNumber />
            </Form.Item>
            <Form.Item name="data_rozpoczecia" label="Data rozpoczęcia i zakończenia" {...rangeConfig} required>
                <RangePicker format="DD-MM-YYYY" onChange={onChange} />
            </Form.Item>

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
            <Form.Item
                label="Powiązany z podróżami"
            >
                <Table
                    rowSelection={rowJourneySelection}
                    columns={columns_journey}
                    dataSource={journeyData}
                />
            </Form.Item>
            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit" loading={loading}>
                    Dodaj etap
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddEtap
