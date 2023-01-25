import { Button, DatePicker, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";

import config from '../../config.json'


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
const AddClients = () => {
    const [form] = Form.useForm();

    const [loading, setLoading] = useState(false);
    useEffect(() => {
    }, [])

    const onFinish = (values: any) => {

        values.data_urodzenia = values.data_urodzenia.format('DD-MM-  YYYY');
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };

        setLoading(true);
        fetch(config.SERVER_URL + "/api/push/client", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {

                    console.log(response)
                    setTimeout(function () {
                        window.open('/klienty', '_self')
                    }, 2.0 * 1000);
                } else {
                    setLoading(false);
                    message.error("Wystąpił błąd podczas dodawania clienta, klient o podanym PESEL już istnieje")
                }

            }).then(() => {


            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowego klienta</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item
                name="pesel"
                label="PESEL"
                rules={[
                    {
                        required: true,
                        message: 'Pole PESEL nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value.length != 11) {
                                return Promise.reject('PESEL musi być długości 11');
                            }
                            return Promise.resolve();
                        },
                    }, {
                        validator: (rule, value) => {
                            if (isNaN(+value)) {
                                return Promise.reject('PESEL musi skladać sie z cyfr');
                            }
                            return Promise.resolve();
                        },
                    }

                ]}
            >
                <Input />
            </Form.Item>
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
            <Form.Item name="data_urodzenia" label="Data urodzenia" {...config}
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwisko nie może być puste!',
                    },
                ]}
            >
                <DatePicker format="DD-MM-YYYY" />
            </Form.Item>
            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj klienta
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddClients
