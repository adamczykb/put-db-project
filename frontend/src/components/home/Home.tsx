import { render } from "@testing-library/react";
import { Button, Collapse, List, Popconfirm, Space, Table, Tag, } from "antd"
import { useEffect, useState } from "react";
import { text } from "stream/consumers";
import getClientsData from "../../utils/adapter/getClientsData";
import getPilotData from "../../utils/adapter/getPilotData";
import removeClient from "../../utils/adapter/removeClient";
const { Panel } = Collapse;

const ClientsView = () => {
    const handleDelete = (key: React.Key) => {

    };

    const [data, setData] = useState([]);
    useEffect(() => {
        getClientsData(setData)
    }, [])
    const columns = [
        {
            title: 'Pesel',
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
            title: 'Numer telefonu',
            key: 'telefon',
            render: (text: any, record: any) => <>{record.numer_telefonu}</>,
        },
        {
            title: 'Addres',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'adres',
        },

        {
            title: 'Data_urodzenia',
            key: 'data_urodzenia',
            render: (text: any, record: any) => <>{record.data_urodzenia}</>,
        },

        {
            title: 'Numer telefonu',
            key: 'numer_telefonu',
            render: (text: any, record: any) => <>{record.numer_telefonu}</>,
        },
        {
            title: 'Podróże',
            key: 'podroze',
            render: (text: any, record: any) =>
                <>{record.podroze.length > 0 ?
                    <Collapse >
                        <Panel header={record.podroze.length > 4 ? "Uczęsniczy w " + record.atrakcje.length + " podróżach" : "Uczęsniczy w " + record.podroze.length + " podróżach"} key="1">
                            <List
                                bordered
                                dataSource={record.podroze}
                                renderItem={(item: any) => (
                                    <List.Item>
                                        {item.nazwa}
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse >
                    :
                    <>Brak danych</>

                }</>
        },
        {
            title: 'Akcja',
            render: (text: any, record: any) => <>
                <a href={"/klienty/edycja/" + record.pesel}>Edytuj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removeClient(record.pesel)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Klienty</h2>
            <Space><Button type="primary" onClick={() => { window.open('/klienty/dodaj') }}>Dodaj klienta</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default ClientsView
