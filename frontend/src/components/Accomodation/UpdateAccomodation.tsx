import { Button, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";

import config from '../../config.json'
import { useParams } from "react-router-dom";
import getCertainAccommodation from "../../utils/adapter/getCertainAccomodationData";
import getJourneyData from "../../utils/adapter/getJourneyData";
import { stringToDate } from "../home/UpdateClient";
import addAccommodationToJourney from "../../utils/adapter/addAccommodationToJourney";
import { onlyUnique } from "../Pilots/UpdatePilot";


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
}; const columns_journey = [
    {
        title: 'Nazwa',
        key: 'nazwa',
        render: (text: any, record: any) => <>{record.nazwa}</>,
        sorter: (a: any, b: any) => a.nazwa.localeCompare(b.nazwa),
    },
    {
        title: 'Cena',
        key: 'cena',
        render: (text: any, record: any) => <>{record.cena}zł</>,
        sorter: (a: any, b: any) => a.cena - b.cena,
    },
    {
        title: 'Data rozpoczecia',
        key: 'data_rozpoczecia',
        render: (text: any, record: any) => <>{record.data_rozpoczecia.split(' ')[0]}</>,
        sorter: (a: any, b: any) => stringToDate(a.data_rozpoczecia.split(' ')[0], "yyyy-mm-dd", '-').getTime() - stringToDate(b.data_rozpoczecia.split(' ')[0], "yyyy-mm-dd", '-').getTime(),
    },
    {
        title: 'Data ukonczenia',
        key: 'data_ukonczenia',
        render: (text: any, record: any) => <>{record.data_ukonczenia.split(' ')[0]}</>,
        sorter: (a: any, b: any) => stringToDate(a.data_ukonczenia.split(' ')[0], "yyyy-mm-dd", '-').getTime() - stringToDate(b.data_ukonczenia.split(' ')[0], "yyyy-mm-dd", '-').getTime(),
    },
]
const UpdateAccommodation = () => {
    const { id } = useParams();
    const [form] = Form.useForm();
    const [data, setData] = useState({ id: 0, nazwa: '', koszt: "", ilosc_miejsc: '', standard_zakwaterowania: '', adres: '', podroze: [] });


    const [loading, setLoading] = useState(false);
    const [selectedJounrneyKeys, setSelectedJounrneyKeys] = useState<React.Key[]>([]);
    const [journeyData, setJourneyData] = useState();
    const onSelectLanguagesChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedJounrneyKeys(newSelectedRowKeys);
    };
    const rowJourneySelection = {
        selectedRowKeys: selectedJounrneyKeys,
        preserveSelectedRowKeys: false,
        onChange: onSelectLanguagesChange,
    };


    useEffect(() => {
        getCertainAccommodation(id, setData)
        getJourneyData(setJourneyData)
    }, [])
    useEffect(() => {
        form.setFieldsValue(data)
        let podroze: any = []
        data.podroze.map((value: any) => {
            podroze.push(value.id)
        })
        setSelectedJounrneyKeys(podroze)

    }, [data])
    const onFinish = (values: any) => {
        values.id = Number(id)

        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };
        setLoading(true)
        fetch(config.SERVER_URL + "/api/update/certain_accommodation", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    message.success('Udało się zaktualizować zakwaterowanie')
                    selectedJounrneyKeys.filter(onlyUnique).map((value: any) => {
                        addAccommodationToJourney(Number(id), value)
                    })
                    setTimeout(function () {
                        window.open('/zakwaterowanie', '_self')
                    }, 2.0 * 1000);

                } else {
                    setLoading(false)
                    message.error("Wystąpił błąd podczas edycję zakwaterowania, odśwież strone i spróbuj ponownie")
                }

                return response
            }).then((response) => {

            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));


    };
    return <>
        <h2>Edycja zakwaterowania</h2>
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
                        message: 'Pole imię nie może być puste!',
                    },
                ]}
            >
                <Input value={data.nazwa} />
            </Form.Item>
            <Form.Item
                name="koszt"
                label="Koszt"
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwisko nie może być puste!',
                    },
                ]}
            >
                <InputNumber value={data.koszt} />
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
                name="ilosc_miejsc"
                label="Ilosc miejsc"
                rules={[
                    {
                        required: true,
                        message: 'Pole numer telefonu nie może być puste!',
                    },

                ]}
            >
                <InputNumber value={data.ilosc_miejsc} />
            </Form.Item>

            <Form.Item
                name="standard_zakwaterowania"
                label="Standard zakwaterowania"
                rules={[
                    {
                        required: true,
                        message: 'Pole standard zakwaterowania nie może być puste!',
                    },

                ]}
            >
                <Input value={data.standard_zakwaterowania} />
            </Form.Item>
            <Form.Item
                label="Powiązany z podróżami"
            >
                <Table
                    rowSelection={rowJourneySelection}
                    columns={columns_journey}
                    dataSource={journeyData}
                />
            </Form.Item>

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit" loading={loading}>
                    Zaktualizuj zakwaterowanie
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default UpdateAccommodation
