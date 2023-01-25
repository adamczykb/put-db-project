import { Button, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";
import getAllAttractions from "../../utils/adapter/getAllAttractions";
import getAllLanguages from "../../utils/adapter/getAllLanguages";

import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
import { useParams } from "react-router-dom";
import getCertainPilot from "../../utils/adapter/getCertainPilotData";
import { clear } from "console";
import getAllAccommodationData from "../../utils/adapter/getAllAccommodationData";
import getCertainAccommodation from "../../utils/adapter/getCertainAccommodation";



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
const UpdateTransportCompany = () => {
    const { id } = useParams();
    const [form] = Form.useForm();
    const [data, setData] = useState({ id: 0, nazwa: '', numer_telefonu: '', adres: ''});
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
        //getCertainAccommodation(id,setData)
        // getAllAttractions(setAttractionData)
        // getAllLanguages(setLanguagesData)
        // getCertainPilot(id, setData)
    }, [])
    useEffect(() => {
        form.setFieldsValue(data)
      
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

        fetch(config.SERVER_URL + "/api/update/certain_transport_company", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                 
                    console.log(values);
                   
                    console.log(response)

                    setTimeout(function () {
                        window.open('/firma_transportowa', '_self')
                      }, 2.0 * 1000);

                } else {
                    message.error("Wystąpił błąd podczas edycję firmy transportowej, odśwież strone i spróbuj ponownie")
                }
               
                return response
            }).then((response) => {

            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
            
       
    };
    return <>
        <h2>Edycja firmy transportowej</h2>
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
                //initialValue={data.imie}
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwa nie może być puste!',
                    },
                ]}
            >
                <Input value={data.nazwa}/>
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
            

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Zgłoś zmiany
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default UpdateTransportCompany