import { Button, DatePicker, Form, Input, InputNumber, message, Table, Typography } from "antd";
import { useEffect, useState } from "react";


import config from '../../config.json'
import { useParams } from "react-router-dom";
import getCertainClient from "../../utils/adapter/getCertainClientData";

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

const UpdateClient = () => {
    const { pesel } = useParams();
    const [form] = Form.useForm();
    const [data, setData] = useState({ pesel: '', imie: '', nazwisko: "", adres: '', numer_telefonu: '', data_urodzenia: '' });
    const [loading, setLoading] = useState(false);
    useEffect(() => {
        getCertainClient(pesel, setData)
        console.log(data)
    }, [])
    useEffect(() => {
        form.setFieldsValue(data)
    }, [data])
    const onFinish = (values: any) => {

        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };
        setLoading(true);
        fetch(config.SERVER_URL + "/api/update/certain_client", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                console.log(values);
                if (response.status == 200) {
                    setTimeout(function () {
                        window.open('/klienty', '_self')
                    }, 2.0 * 1000);
                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas edycji klienta, odśwież strone i spróbuj ponownie")
                }

            }).catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Edycja klienta</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >
            <Form.Item hidden
                name="pesel"
                label="Pesel"

            >
                <Input readOnly value={data.pesel} />
            </Form.Item>
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
                <Input value={data.imie} />
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
            <Form.Item hidden name="data_urodzenia" label="Data urodzenia" {...config}>
                <Input hidden />
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


            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit" loading={loading}>
                    Edytuj klienta
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default UpdateClient
