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
const AddLang = () => {
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

        fetch(config.SERVER_URL + "/api/push/language", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    
                    console.log(response)
                    setTimeout(function () {
                        window.open('/jezyki', '_self')
                      }, 2.0 * 1000);
                } else {
                    message.error("Wystąpił błąd podczas dodawania przewodnika, odśwież strone i spróbuj ponownie")
                }

            }).then(()=>{
           
            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowego języka</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item
                name="kod"
                label="Kod"
                rules={[
                    {
                        required: true,
                        message: 'Pole kod nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="nazwa"
                label="Nazwa"
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwisko nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            
            
            

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj język
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddLang
