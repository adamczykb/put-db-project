import { render } from "@testing-library/react";
import { Collapse, List, Popconfirm, Table, Tag, } from "antd"
import { useEffect, useState } from "react";
import { text } from "stream/consumers";
import getClientsData from "../../utils/adapter/getClientsData";
import getPilotData from "../../utils/adapter/getPilotData";
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
            title: 'Numer telefonu',
            key: 'data_urodzenia',
            render: (text: any, record: any) => <>{record.data_urodzenia}</>,
        },

        {
            title: 'Podróże',
            key: 'podroze',
            render: (text: any, record: any) =>
                <>{record.podroze.length > 0 ?
                    <Collapse >
                        <Panel header={record.podroze.length > 4 ? "Obsługuje " + record.atrakcje.length + " podróże" : "Obsługuje " + record.podroze.length + " podróży"} key="1">
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
                <a href={"/klienty/dodaj/"}>dodaj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => handleDelete(record.pesel)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Clienty</h2>
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default ClientsView
