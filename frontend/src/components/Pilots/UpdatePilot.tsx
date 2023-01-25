import { Button, Form, Input, message, Table } from "antd";
import { useEffect, useState } from "react";
import getAllAttractions from "../../utils/adapter/getAllAttractions";
import getAllLanguages from "../../utils/adapter/getAllLanguages";

import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
import { useParams } from "react-router-dom";
import getCertainPilot from "../../utils/adapter/getCertainPilotData";
import { clear } from "console";


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
function onlyUnique(value: any, index: any, self: any) {
    return self.indexOf(value) === index;
  }
const UpdatePilot = () => {
    const { id } = useParams();
    const [form] = Form.useForm();
    const [data, setData] = useState({ key: 0, id: 0, imie: '', nazwisko: "", adres: '', numer_telefonu: '', jezyki: [], podroze: [], atrakcje: [] });
    const [selectedAttractionKeys, setSelectedAttractionKeys] = useState<React.Key[]>([]);
    const [attractionData, setAttractionData] = useState();
    const onSelectAttractionChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedAttractionKeys(newSelectedRowKeys.filter(onlyUnique));
    };
    
    const rowAttractionSelection = {
        
        selectedRowKeys: selectedAttractionKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectAttractionChange,

    };

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

    function getUniqueValues(arr: Array<unknown>): Array<unknown> | unknown {
        if (arr === undefined || !Array.isArray(arr)) return;
        return Array.from(new Set(arr));
    }
    useEffect(() => {
        getAllAttractions(setAttractionData)
        getAllLanguages(setLanguagesData)
        getCertainPilot(id, setData)
    }, [])
    useEffect(() => {
        form.setFieldsValue(data)
        //setSelectedLanguagesKeys([])
        //setSelectedAttractionKeys([])
        let atrakcje: any = []
        let jezyki: any = []
        data.jezyki.map((value: any) => {
            jezyki.push(value.id)
            console.log(value.id)
        })
        data.atrakcje.map((value: any) => {
            atrakcje.push(value.id)
            console.log(value.id)
        })
        setSelectedAttractionKeys(atrakcje)
        setSelectedLanguagesKeys(jezyki)
    }, [data])
    const onFinish = (values: any) => {
        //console.log(values);
        values.id = Number(id)
        values.key = Number(id)
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };

        fetch(config.SERVER_URL + "/api/update/certain_pilot", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    console.log(response.result)
                    console.log(selectedLanguagesKeys);
                    console.log(selectedAttractionKeys);
                    console.log(values);
                    selectedLanguagesKeys.filter(onlyUnique).map((value: any) => {
                        addLanguageToPilot(value, response.result)
                    })
                    selectedAttractionKeys.filter(onlyUnique).map((value: any) => {
                        addAttractionToPilot(value, response.result)
                    })
                    console.log(response)
                } else {
                    message.error("Wystąpił błąd podczas dodawania przewodnika, odśwież strone i spróbuj ponownie")
                }
                //window.open("/przewodnicy")
                //window.close();
                return response
            }).then((response) => {

            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
            
        // window.open("/przewodnicy")
        // window.close();
    };
    return <>
        <h2>Edycja przewodnika</h2>
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
                //initialValue={data.imie}
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
                <Input value={data.nazwisko} />
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
                <Input value={data.adres} />
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
                <Input value={data.numer_telefonu} />
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
                    Zgłoś zmiany
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default UpdatePilot