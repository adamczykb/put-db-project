import { Button, DatePicker, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";
// import getAllAttractions from "../../utils/adapter/getAllAttractions";
// import getAllLanguages from "../../utils/adapter/getAllLanguages";

import config from '../../config.json'
import addTransportCompanyToTransport from "../../utils/adapter/addTransportCompanyToTransport";
import getTransportCompanyData from "../../utils/adapter/getTransportCompanyData";
import getTransportData from "../../utils/adapter/getTransportData";
// import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
// import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
const { RangePicker } = DatePicker;

const rangeConfig = {
    rules: [{ type: 'array' as const, required: true, message: 'Proszę wybrać date i godzine' }],
};
const transport = {

}
const onFinish = (values: any) => {
};

const firma_transportowa_columns = [
    {
        title: 'id',
        key: 'id',
        render: (text: any, record: any) => <>{record.id}</>,
    },
    {
        title: 'Nazwa',
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
        render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
        key: 'adres',
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
    const [selectedAttractionKeys, setSelectedTransportKeys] = useState<React.Key[]>([]);
    const [transportData, setTransportData] = useState();
    const onSelectTransportChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedTransportKeys(newSelectedRowKeys);
    };
    const rowTransportSelection = {
        selectedAttractionKeys,
        onChange: onSelectTransportChange,
    };
    const [selectedFirmaKeys, setSelectedFirmaKeys] = useState<React.Key[]>([]);
    const [firmaData, setFirmaData] = useState();
    const onSelectFirmaChange = (newSelectedRowKeys: React.Key[]) => {
        console.log('selectedRowKeys changed: ', newSelectedRowKeys);
        setSelectedFirmaKeys(newSelectedRowKeys);
    };
    const rowFirmaSelection = {
        selectedFirmaKeys,
        onChange: onSelectFirmaChange,
    };


    useEffect(() => {
        getTransportCompanyData(setFirmaData)
        getTransportData(setTransportData)
        //getFirmaTransportowa(setFirmaData)
        // getAllAttractions(setTransportData)
        // getAllLanguages(setLanguagesData)
    }, [])

    const onFinish = (values: any) => {
        
        const transport={
            nazwa: values.nazwa,
            liczba_jednostek: values.liczba_jednostek,
            liczba_miejsc: values.liczba_miejsc,

        }
        const out={
            punkt_poczatkowy: values.punkt_poczatkowy,
            punkt_konczowy: values.punkt_konczowy,
            koszt: values.koszt,
            data_poczatkowa: values.data_rozpoczecia[0].format('DD-MM-YYYY'),
            data_koncowa: values.data_rozpoczecia[1].format('DD-MM-YYYY'),
            
            transport
        }
        console.log(out)
        // values.transport=[nazwa : values.nazwa,liczba_jednostek,liczba_miejsc];
        console.log(values);
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: out })
        };
        const join={
            firma_transportowa_id: selectedFirmaKeys,
        }
        fetch(config.SERVER_URL + "/api/push/etap", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedFirmaKeys.map((value: any) => {
                         addTransportCompanyToTransport(value, response.result)
                     })
                    // selectedAttractionKeys.map((value: any) => {
                    //     // addAttractionToPilot(value, response.result)
                    // })
                    console.log(response)
                    setTimeout(function () {
                        window.open('/etapy', '_self')
                      }, 2.0 * 1000);
                } else {
                    message.error("Wystąpił błąd podczas dodawania przewodnika, odśwież strone i spróbuj ponownie")
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
                label="Koszt"
                rules={[
                    {
                        required: true,
                        message: 'Pole adres nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value <= 0) {
                                return Promise.reject('Koszt musi być większy niż 0');
                            }
                            return Promise.resolve();
                        },
                    }
                ]}
            >
                <InputNumber />
            </Form.Item>
            <Form.Item name="data_rozpoczecia" label="Data rozpoczęcia i zakończenia" {...rangeConfig} required>
                <RangePicker format="DD-MM-YYYY"  
                 
                />
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
                        if (value <= 0) {
                            return Promise.reject('Ilosc miejsc musi być większy niż 0');
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
                        if (value <= 0) {
                            return Promise.reject('Ilosc miejsc musi być większy niż 0');
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
                label="Powiązany z atrakcjami"
            >
                <Table
                    rowSelection={rowFirmaSelection}
                    columns={firma_transportowa_columns}
                    dataSource={firmaData}
                />
            </Form.Item>


            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj etap
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddEtap
