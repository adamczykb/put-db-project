import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";
import getAllAttractions from "../../utils/adapter/getAllAttractions";
import getAllLanguages from "../../utils/adapter/getAllLanguages";

import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
import addLanguageToWorker from "../../utils/adapter/addLanguageToWorker";
import getCertainWorker from "../../utils/adapter/getCertainWorker";
import { useParams } from "react-router-dom";
import getJourneyData from "../../utils/adapter/getJourneyData";
import { stringToDate } from "../home/UpdateClient";
import addWorkerToJourney from "../../utils/adapter/addWorkerToJourney";
import { onlyUnique } from "../Pilots/UpdatePilot";

const onFinish = (values: any) => {
};
const languages_columns = [
    {
        title: 'Kod języka',
        key: 'kod',
        render: (text: any, record: any) => <>{record.kod}</>,
    },
    {
        title: 'Język',
        key: 'jezyk',
        render: (text: any, record: any) => <>{record.nazwa}</>,
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
}; const columns_journey = [
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
const UpdateEmployee = () => {
    const [form] = Form.useForm();
    const { id } = useParams()
    const [data, setData] = useState({ jezyki: [], podroze: [] })
    const [selectedLanguagesKeys, setSelectedLanguagesKeys] = useState<React.Key[]>([]);
    const [languagesData, setLanguagesData] = useState();
    const onSelectLanguagesChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedLanguagesKeys(newSelectedRowKeys);
    };
    const rowLanguagesSelection = {
        selectedRowKeys: selectedLanguagesKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectLanguagesChange,
    };

    const [selectedJounrneyKeys, setSelectedJounrneyKeys] = useState<React.Key[]>([]);
    const [journeyData, setJounrneyData] = useState();
    const onSelectJourneyChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedJounrneyKeys(newSelectedRowKeys);

    };
    const rowJourneySelection = {
        selectedRowKeys: selectedJounrneyKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectJourneyChange,
    };

    useEffect(() => {
        getCertainWorker(id, setData)
        getAllLanguages(setLanguagesData)
        getJourneyData(setJounrneyData);
    }, [])

    useEffect(() => {
        form.setFieldsValue(data)
        let jezyk: any = []
        data.jezyki.map((value: any) => {
            jezyk.push(value.kod)
        })
        let podroze: any = []
        data.podroze.map((value: any) => {
            podroze.push(value.id)
        })
        console.log(podroze)
        setSelectedLanguagesKeys(jezyk)
        setSelectedJounrneyKeys(podroze)
    }, [data])
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

        fetch(config.SERVER_URL + "/api/update/certain_worker", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedLanguagesKeys.filter(onlyUnique).map((value: any) => {
                        addLanguageToWorker(value, Number(id))
                    })
                    selectedJounrneyKeys.filter(onlyUnique).map((value: any) => {
                        addWorkerToJourney(Number(id), value)
                    })
                    message.success("Pracownik poprawnie zaktualizowany")
                    setTimeout(function () {
                        window.open('/pracownicy', '_self')
                    }, 2.0 * 1000);
                } else {
                    message.error("Wystąpił błąd podczas aktualizowania przewodnika, odśwież strone i spróbuj ponownie")
                }

            }).catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Edycja pracownika</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item
                name="imie"
                label="Imię"
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
                name="nazwisko"
                label="Nazwisko"
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwisko nie może być puste!',
                    },
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
                name="numer_telefon"
                label="Numer telefonu"
                rules={[
                    {
                        required: true,
                        message: 'Pole numer telefonu nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (!/^\+?[0-9]{10,11}$/.test(value)) {
                                return Promise.reject('Numer telefonu jest nieprawidłowy');
                            }
                            return Promise.resolve();
                        }
                    }
                ]}
            >
                <Input />
            </Form.Item>
            {/* <Form.Item
                label="Powiązany z atrakcjami"
            >
                <Table
                    rowSelection={rowAttractionSelection}
                    columns={attraction_columns}
                    dataSource={attractionData}
                />
            </Form.Item> */}
            <Form.Item
                label="Zna języki"
            >
                <Table
                    rowSelection={rowLanguagesSelection}
                    columns={languages_columns}
                    dataSource={languagesData}
                />
            </Form.Item>
            <Form.Item
                name=""
                label="Powiązany z podróżami"
            >
                <Table columns={columns_journey} dataSource={journeyData}
                    rowSelection={rowJourneySelection}
                />
            </Form.Item>

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Zaktualizuj pracownika
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default UpdateEmployee;
