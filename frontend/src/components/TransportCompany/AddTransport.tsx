import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";


import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
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

        fetch(config.SERVER_URL + "/api/push/transport_company", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                     selectedLanguagesKeys.map((value: any) => {
                         addTransportCompanyToTransport(value, response.result)
                     })
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
                name="nazwa"
                label="Nazwa"
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwa nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="liczba_jednostek"
                label="Liczba jednostek"
                rules={[
                    {
                        required: true,
                        message: 'Pole liczba jednostek nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value <= 0) {
                                return Promise.reject('Ilosc miejsc musi być większy niż 0');
                            }
                            return Promise.resolve();
                        },
                    }
                ]}
            >
                <Input />
            </Form.Item>

            <Form.Item
                name="liczba_miejsc"
                label="Liczba miejsc"
                rules={[
                    {
                        required: true,
                        message: 'Pole liczba miejsc nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value <= 0) {
                                return Promise.reject('Ilosc miejsc musi być większy niż 0');
                            }
                            return Promise.resolve();
                        },
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
