import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";


import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
import getTransportCompanyData from "../../utils/adapter/getTransportCompanyData";

const onFinish = (values: any) => {
};
const transport_company_columns = [
    {
        title: 'ID',
        key: 'id',
        render: (record:any)=> <>{record.id}</>,
    },
    {
        title: 'Firma transportowa',
        key: 'nazwa',
        render: (text: any, record: any) => <>{record.nazwa}</>,
    },
    {
        title: 'Numer telefonu',
        key: 'telefon',
        render: (text: any, record: any) => <>{record.telefon}</>,
    },
   
    {
        title: 'Adres',
        key: 'adres',
        render: (text: any, record: any) => <>{record.adres}</>,
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
    const [selectedTransportCompanyKeys, setSelectedTransportCompanyKeys] = useState<React.Key[]>([]);
    const [transportCompanyData, setTransportCompanyData] = useState();
    const onSelectAttractionChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedTransportCompanyKeys(newSelectedRowKeys);
    };
    const rowTransportCompanySelection = {
        selectedAttractionKeys: selectedTransportCompanyKeys,
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
        //getTransportCompanyData(setTransportCompanyKeys)
        getTransportCompanyData(setTransportCompanyData)
        
        // getAllAttractions(setAttractionData)
        // getAllLanguages(setLanguagesData)
    }, [])

    const onFinish = (values: any) => {
        values.id=selectedTransportCompanyKeys[0];
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };

        fetch(config.SERVER_URL + "/api/push/transport_company_transport", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    // selectedLanguagesKeys.map((value: any) => {
                    //     addLanguageToPilot(value, response.result)
                    // })
                    // selectedTransportCompanyKeys.map((value: any) => {
                    //     addAttractionToPilot(value, response.result)
                    // })
                    console.log(response)
                } else {
                    message.error("Wystąpił błąd podczas dodawania transporu, odśwież strone i spróbuj ponownie")
                }

            }).then(()=>{
                window.open('/transporty')
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
                label="Powiązany z firmami"
            >
                <Table
                    rowSelection={rowTransportCompanySelection}
                    columns={transport_company_columns}
                    dataSource={transportCompanyData}
                />
            </Form.Item>
          

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj transport
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddTransport
