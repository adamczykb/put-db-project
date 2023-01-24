import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getJourneyData from "../../utils/adapter/getJourneyData";
import removeJourney from "../../utils/adapter/removeJourney";

const { Panel } = Collapse;

const JourneysView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getJourneyData(setData)
    }, [])
    const columns = [
        {
            title: 'Nazwa',
            key: 'nazwa',
            render: (text: any, record: any) => <>{record.nazwa}</>,
        },
        {
            title: 'Cena',
            key: 'cena',
            render: (text: any, record: any) => <>{record.cena}</>,
        },
        {
            title: 'Data rozpoczecia',
            key: 'data_rozpoczecia',
            render: (text: any, record: any) => <>{record.data_rozpoczecia}</>,
        },
        {
            title: 'Data ukonczenia',
            key: 'data_ukonczenia',
            render: (text: any, record: any) => <>{record.data_ukonczenia}</>,
        },
         {
            title: 'Opis',
            key: 'opis',
            render: (text: any, record: any) => <>{record.opis}</>,
        },
        
        
        
        {
            title: 'Atrakcje',
            key: 'atrakcje',
            render: (text: any, record: any) =>
                <>{record.atrakcje.length > 0 ?

                    <Collapse >
                        <Panel header={record.atrakcje.length > 4 ? "Obsługuje " + record.atrakcje.length + " atracje" : "Obsługuje " + record.atrakcje.length + " atrakcje"} key="1">
                            <List
                                bordered
                                dataSource={record.atrakcje}
                               
                                renderItem={(item: any) => (
                                    
                                    <List.Item>
                                        Nazwa: {item.nazwa}, adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> 
                                        , opis: {item.opis}, koszt: {item.koszt}.
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
        },
        {
            title: 'Etapy',
            key: 'etapy',
            render: (text: any, record: any) =>
                <>{record.etapy.length > 0 ?

                    <Collapse >
                        <Panel header={record.etapy.length > 4 ? "Obsługuje " + record.etapy.length + " atracje" : "Obsługuje " + record.etapy.length + " atrakcje"} key="1">
                            <List
                                bordered
                                dataSource={record.etapy}
                               
                                renderItem={(item: any) => (
                                    
                                    <List.Item>
                                        Nazwa: {item.nazwa}, adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> 
                                        , opis: {item.opis}, koszt: {item.koszt}.
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
        },
       
        {
            title: 'Akcja',
            render: (text: any, record: any) => <>
                <a href={"/podrozy/edycja/" + record.id}>Edytuj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removeJourney(record.key)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Podróży</h2>
            <Space><Button type="primary" onClick={() => { window.open('/podrozy/dodaj') }}>Dodaj podróż</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default JourneysView