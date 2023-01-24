import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";
import getAllAttractions from "../../utils/adapter/getAllAttractions";
import getAllLanguages from "../../utils/adapter/getAllLanguages";

import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";

const onFinish = (values: any) => {
};
const attraction_columns = [
    {
        title: 'Atrakcja',
        key: 'atrakcja',
        render: (text: any, record: any) => <>{record.nazwa}</>,
    },
    {
        title: 'Adres',
        key: 'adres',
        render: (text: any, record: any) => <>{record.adres}</>,
    },
    {
        title: 'Opis',
        key: 'opis',
        render: (text: any, record: any) => <>{record.opis}</>,
    },
]
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
};
const AddPilot = () => {
    const [form] = Form.useForm();
    const [selectedAttractionKeys, setSelectedAttractionKeys] = useState<React.Key[]>([]);
    const [attractionData, setAttractionData] = useState();
    const onSelectAttractionChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedAttractionKeys(newSelectedRowKeys);
    };
    const rowAttractionSelection = {
        selectedAttractionKeys,
        onChange: onSelectAttractionChange,
    };
    const [selectedLanguagesKeys, setSelectedLanguagesKeys] = useState<React.Key[]>([]);
    const [languagesData, setLanguagesData] = useState();
    const onSelectLanguagesChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedLanguagesKeys(newSelectedRowKeys);
    };
    const rowLanguagesSelection = {
        selectedLanguagesKeys,
        onChange: onSelectLanguagesChange,
    };

    useEffect(() => {
        getAllAttractions(setAttractionData)
        getAllLanguages(setLanguagesData)
    }, [])

    const onFinish = (values: any) => {
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };

        fetch(config.SERVER_URL + "/api/push/pilot", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedLanguagesKeys.map((value: any) => {
                        addLanguageToPilot(value, response.result)
                    })
                    selectedAttractionKeys.map((value: any) => {
                        addAttractionToPilot(value, response.result)
                    })
                    console.log(response)
                } else {
                    message.error("Wystąpił błąd podczas dodawania przewodnika, odśwież strone i spróbuj ponownie")
                }

            }).then(()=>{
                window.open('/przewodnicy')
            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowego przewodnika</h2>
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
                name="numer_telefonu"
                label="Numer telefonu"
                rules={[
                    {
                        required: true,
                        message: 'Pole numer telefonu nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                          if (!/^\+?[0-9]{10,15}$/.test(value)) {
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
                label="Powiązany z atrakcjami"
            >
                <Table
                    rowSelection={rowAttractionSelection}
                    columns={attraction_columns}
                    dataSource={attractionData}
                />
            </Form.Item>
            <Form.Item
                label="Zna języki"
            >
                <Table
                    rowSelection={rowLanguagesSelection}
                    columns={languages_columns}
                    dataSource={languagesData}
                />
            </Form.Item>

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj przewodnika
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddPilot
