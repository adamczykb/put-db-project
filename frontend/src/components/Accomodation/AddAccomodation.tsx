import { Button, DatePicker, Form, Input, InputNumber, message, Table } from "antd";
import { useState } from "react";

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
const AddAccommodanion = () => {
    const [form] = Form.useForm();

    const [loading, setLoading] = useState(false);
    form.setFieldsValue({ koszt: 0, ilosc_miejsc: 0 })
    const onFinish = (values: any) => {
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };
        setLoading(true)

        fetch(config.SERVER_URL + "/api/push/accommodation", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    console.log(response)
                    message.success("Udało się dodać zakwaterowanie")
                    setTimeout(function () {
                        window.open('/zakwaterowanie', '_self')
                    }, 2.0 * 1000);
                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas dodawania zakwaterowania, zostało już ono dodane")
                }

            }).catch((error) => message.error('Błąd połączenia z serwerem'));

    };
    return <>
        <h2>Dodawanie nowego zakwaterowania</h2>
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
                name="koszt"
                label="Koszt"
                rules={[
                    {
                        required: true,
                        message: 'Pole koszt nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value < 0) {
                                return Promise.reject('Koszt musi nie moze być ujemny');
                            }
                            return Promise.resolve();
                        },
                    }
                ]}
            >
                <InputNumber />
            </Form.Item>




            <Form.Item
                name="ilosc_miejsc"
                label="Ilosc miejsc"
                rules={[
                    {
                        required: true,
                        message: 'Pole ilosc miejsc nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value < 0) {
                                return Promise.reject('Ilosc miejsc nie może być ujmena');
                            }
                            return Promise.resolve();
                        },
                    }
                ]}
            >
                <InputNumber />
            </Form.Item>
            <Form.Item
                name="standard_zakwaterowania"
                label="Standard zakwaterowania"
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


            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit" loading={loading}>
                    Dodaj zakwaterowanie
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddAccommodanion
