import { Collapse, List, Popconfirm, Table, Tag, } from "antd"
import { useEffect, useState } from "react";
import getPilotData from "../../utils/adapter/getPilotData";
const { Panel } = Collapse;

const PilotsView = () => {
    const handleDelete = (key: React.Key) => {

    };

    const [data, setData] = useState([]);
    useEffect(() => {
        getPilotData(setData)
    }, [])
    const columns = [
        {
            title: 'Przewodnik',
            key: 'pilot',
            render: (text: any, record: any) => <>{record.imie + ' ' + record.nazwisko}</>,
        },
        {
            title: 'Numer telefonu',
            key: 'telefon',
            render: (text: any, record: any) => <>{record.numer_telefonu}</>,
        },
        {
            title: 'Addres',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'addres',
        },
        {
            title: 'Atrakcje',
            key: 'atrakcje',
            render: (text: any, record: any) =>
                <>{record.atrakcje.length > 0 ?

                    <Collapse >
                        <Panel header={record.atrakcje.length > 4 ? "Obsługuje " + record.atrakcje.length + " atrkacji" : "Obsługuje " + record.atrakcje.length + " atrakcje"} key="1">
                            <List
                                bordered
                                dataSource={record.atrakcje}
                                renderItem={(item: any) => (
                                    <List.Item>
                                        {item.nazwa}
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
        },
        {
            title: 'Znane języki',
            render: (text: any, record: any) =>
                <>{record.jezyki.length > 0 ? <>{record.jezyki.map((value: any) => <Tag>{value.nazwa}</Tag>)}</> : <>Brak danych</>}</>
        },
        {
            title: 'Podróże',
            key: 'podroze',
            render: (text: any, record: any) =>
                <>{record.atrakcje.length > 0 ?
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
                <a href={"/przewodnicy/edycja/" + record.id}>Edytuj</a><br />
                <a href={"/przewodnicy/dodaj/"}>dodaj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => handleDelete(record.id)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Przewodnicy</h2>
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default PilotsView
