import { Button, DatePicker, Form, Input, InputNumber, message, Table } from "antd";
import { useEffect, useState } from "react";
import getAllAttractions from "../../utils/adapter/getAllAttractions";

import config from '../../config.json'
import getAllPilots from "../../utils/adapter/getAllPilots";
import getAllClientsData from "../../utils/adapter/getAllClientsData";
import getAllEtaps from "../../utils/adapter/getAllEtaps";
import getAllWorkers from "../../utils/adapter/getAllWorkersData";
import getAllAccommodationData from "../../utils/adapter/getAllAccommodationData";
import addPilotToJourney from "../../utils/adapter/addPilotToJourney";
import addAttractionToJourney from "../../utils/adapter/addAttractionToJourney";
import addClientToJourney from "../../utils/adapter/addClientsToJourney";

import addEtapToJourney from "../../utils/adapter/addEtapToJourney";
import addWorkerToJourney from "../../utils/adapter/addWorkerToJourney";
import addAccommodationToJourney from "../../utils/adapter/addAccommodationToJourney";
const { RangePicker } = DatePicker;

const rangeConfig = {
    rules: [{ type: 'array' as const, required: true, message: 'Proszę wybrać date i godzine' }],
};


const pilot_columns = [
    {
        title: 'id',
        key: 'id',
        render: (text: any, record: any) => <>{record.id}</>,
    },
    {
        title: 'Imie',
        key: 'imie',
        render: (text: any, record: any) => <>{record.imie}</>,
    },
    {
        title: 'Nazwisko',
        key: 'nazwisko',
        render: (text: any, record: any) => <>{record.nazwisko}</>,
    },
    {
        title: 'Adres',
        key: 'adres',
        render: (text: any, record: any) => <>{record.adres}</>,
    },
    {
        title: 'Numer telefonu',
        key: 'numer_telefonu',
        render: (text: any, record: any) => <>{record.numer_telefonu}</>,
    },
]

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
const clients_columns = [
    {
        title: 'pesel',
        key: 'pesel',
        render: (text: any, record: any) => <>{record.pesel}</>,
    },
    {
        title: 'Imie',
        key: 'imie',
        render: (text: any, record: any) => <>{record.imie}</>,
    },
    {
        title: 'Nazwisko',
        key: 'nazwisko',
        render: (text: any, record: any) => <>{record.nazwisko}</>,
    },
    {
        title: 'Adres',
        key: 'adres',
        render: (text: any, record: any) => <>{record.adres}</>,
    },
    {
        title: 'Numer telefonu',
        key: 'numer_telefonu',
        render: (text: any, record: any) => <>{record.numer_telefonu}</>,
    },
    {
        title: 'Data urodzenia',
        key: 'data_urodzenia',
        render: (text: any, record: any) => <>{record.data_urodzenia}</>,
    },
]
const etaps_columns = [
    {
        title: 'id',
        key: 'id',
        render: (text: any, record: any) => <>{record.id}</>,
    },
    {
        title: 'Punkt poczatkowy',
        key: 'punkt_poczatkowy',
        render: (text: any, record: any) => <>{record.punkt_poczatkowy}</>,
    },
    {
        title: 'Punkt konczowy',
        key: 'punkt_konczowy',
        render: (text: any, record: any) => <>{record.punkt_konczowy}</>,
    },
    {
        title: 'Koszt',
        key: 'koszt',
        render: (text: any, record: any) => <>{record.koszt}</>,
    },
    {
        title: 'Data poczatkowa',
        key: 'data_poczatkowa',
        render: (text: any, record: any) => <>{record.data_poczatkowa.split(' ')[0]}</>,
    },
    {
        title: 'Data koncowa',
        key: 'data_koncowa',
        render: (text: any, record: any) => <>{record.data_koncowa.split(' ')[0]}</>,
    },
]
const worker_columns = [
    {
        title: 'id',
        key: 'id',
        render: (text: any, record: any) => <>{record.id}</>,
    },
    {
        title: 'Imie',
        key: 'imie',
        render: (text: any, record: any) => <>{record.imie}</>,
    },
    {
        title: 'Nazwisko',
        key: 'nazwisko',
        render: (text: any, record: any) => <>{record.nazwisko}</>,
    },
    {
        title: 'adres',
        key: 'adres',
        render: (text: any, record: any) => <>{record.adres}</>,
    },
    {
        title: 'Numer telefonu',
        key: 'numer_telefon',
        render: (text: any, record: any) => <>{record.numer_telefon}</>,
    },

]
const accomodation_columns = [
    {
        title: 'ID',
        key: 'id',
        render: (text: any, record: any) => <>{record.id}</>,
    },
    {
        title: 'Nazwa',
        key: 'nazwa',
        render: (text: any, record: any) => <>{record.nazwa}</>,
    },
    {
        title: 'Koszt',
        key: 'koszt',
        render: (text: any, record: any) => <>{record.koszt}</>,
    },
    {
        title: 'Ilosc miejsc',
        key: 'ilosc_miejsc',
        render: (text: any, record: any) => <>{record.ilosc_miejsc}</>,
    },
    {
        title: 'Standard zakwaterowania',
        key: 'standard_zakwaterowania',
        render: (text: any, record: any) => <>{record.standard_zakwaterowania}</>,
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
const AddJourney = () => {
    const [form] = Form.useForm();
    //atrakcji
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
    //piloty
    const [selectedPilotsKeys, setSelectedPilotsKeys] = useState<React.Key[]>([]);
    const [pilotsData, setPilotsData] = useState();
    const onSelectPilotChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedPilotsKeys(newSelectedRowKeys);
    }
    const rowPilotSelection = {
        selectedPilotsKeys,
        onChange: onSelectPilotChange,
    }
    //clienty
    const [selectedClientsKeys, setSelectedClientsKeys] = useState<React.Key[]>([]);
    const [clientsData, setClientsData] = useState();
    const onSelectClientChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedClientsKeys(newSelectedRowKeys);
    }
    const rowClientSelection = {
        selectedClientsKeys,
        onChange: onSelectClientChange,
    }
    //etap
    const [selectedEtapKeys, setSelectedEtapKeys] = useState<React.Key[]>([]);
    const [etapData, setEtapData] = useState();
    const onSelectEtapChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedEtapKeys(newSelectedRowKeys);
    }
    const rowEtapSelection = {
        selectedEtapKeys,
        onChange: onSelectEtapChange,
    }

    //worker
    const [selectedWorkerKeys, setSelectedWorkerKeys] = useState<React.Key[]>([]);
    const [workerData, setWorkerData] = useState();
    const onSelectWorkerChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedWorkerKeys(newSelectedRowKeys);
    }
    const rowWorkerSelection = {
        selectedWorkerKeys,
        onChange: onSelectWorkerChange,
    }

    //accommodation
    const [selectedAccommodationKeys, setSelectedAccommodationKeys] = useState<React.Key[]>([]);
    const [accommodationData, setAccommodationData] = useState();
    const onSelectAccommodationChange = (newSelectedRowKeys: React.Key[]) => {
        setSelectedAccommodationKeys(newSelectedRowKeys);
    }
    const rowAccommodationSelection = {
        selectedAccommodationKeys,
        onChange: onSelectAccommodationChange,
    }

    useEffect(() => {
        getAllAttractions(setAttractionData)
        getAllPilots(setPilotsData)
        getAllEtaps(setEtapData)
        getAllClientsData(setClientsData)
        getAllWorkers(setWorkerData)
        getAllAccommodationData(setAccommodationData)

    }, [])
    const onChange = (data: any) => {
        console.log(data)
        let sendData = {
            id_list: [],
            from: '',
            to: ''
        }

        if (data && data[0] && data[1]) {
            sendData = {
                id_list: [],
                from: data[0].format('DD-MM-YYYY'),
                to: data[1].format('DD-MM-YYYY')
            }
        }


        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: sendData })
        };

        fetch(config.SERVER_URL + "/api/get/certain_etaps", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {

                    setEtapData(response.result)
                } else {
                    message.error("Wystąpił błąd podczas dodawania podróży, podróż o takiej nazwie już istnieje")
                }

            }).then(() => {

            })
            .catch((error) => message.error('nie istnieje etapów w takim przedziału terminowym'));
    }
    const onFinish = (values: any) => {
        const out = {
            nazwa: values.nazwa,
            opis: values.opis,
            cena: values.cena,

            data_rozpoczecia: values.data_rozpoczecia[0].format('DD-MM-YYYY'),
            data_ukonczenia: values.data_rozpoczecia[1].format('DD-MM-YYYY')
        }
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: out })
        };

        fetch(config.SERVER_URL + "/api/push/journey", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    selectedPilotsKeys.map((value: any) => {
                        addPilotToJourney(value, response.result)
                    })
                    selectedAttractionKeys.map((value: any) => {
                        addAttractionToJourney(value, response.result)
                    })
                    selectedClientsKeys.map((value: any) => {
                        addClientToJourney(value, response.result)
                    })
                    selectedEtapKeys.map((value: any) => {
                        addEtapToJourney(value, response.result)
                    })
                    selectedWorkerKeys.map((value: any) => {
                        addWorkerToJourney(value, response.result)
                    })
                    selectedAccommodationKeys.map((value: any) => {
                        addAccommodationToJourney(value, response.result)
                    })
                    console.log(response)
                    setTimeout(function () {
                        window.open('/podrozy', '_self')
                    }, 2.0 * 1000);

                } else {
                    message.error("Wystąpił błąd podczas dodawania podróży, zmień nazwę lub date rozpoczęcia podróży")
                }

            }).then(() => {

            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));

    };
    return <>
        <h2>Dodawanie nowego przewodnika</h2>
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

            <Form.Item name="data_rozpoczecia" label="Data rozpoczęcia i zakończenia" {...rangeConfig} required>
                <RangePicker format="DD-MM-YYYY" onChange={onChange}


                />
            </Form.Item>

            <Form.Item
                name="opis"
                label="Opis"
                rules={[
                    {
                        required: true,
                        message: 'Pole opis nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="cena"
                label="Cena"
                rules={[
                    {
                        required: true,
                        message: 'Pole koszt nie może być puste!',
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
            <Form.Item
                label="Powiązać z atrakcjami"
            >
                <Table
                    rowSelection={rowAttractionSelection}
                    columns={attraction_columns}
                    dataSource={attractionData}
                />
            </Form.Item>
            <Form.Item
                label="Powiązać z przewodnikami"
            >
                <Table
                    rowSelection={rowPilotSelection}
                    columns={pilot_columns}
                    dataSource={pilotsData}
                />
            </Form.Item>

            <Form.Item
                label="Powiązać z klientami"
            >
                <Table
                    rowSelection={rowClientSelection}
                    columns={clients_columns}
                    dataSource={clientsData}
                />
            </Form.Item>
            <Form.Item
                label="Powiązać z etapami"
            >
                <Table
                    rowSelection={rowEtapSelection}
                    columns={etaps_columns}
                    dataSource={etapData}
                />
            </Form.Item>

            <Form.Item
                label="Powiązać z pracownikami"
            >
                <Table
                    rowSelection={rowWorkerSelection}
                    columns={worker_columns}
                    dataSource={workerData}
                />
            </Form.Item>

            <Form.Item
                label="Powiązać z zakwaterowaniami"
            >
                <Table
                    rowSelection={rowAccommodationSelection}
                    columns={accomodation_columns}
                    dataSource={accommodationData}
                />
            </Form.Item>
           

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj podróż
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddJourney
