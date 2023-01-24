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
            title: 'Kierowane przez pracowników',
            key: 'pracownicy',
            render: (text: any, record: any) =>
                <>{record.pracownicy.length > 0 ?

                    <Collapse >
                        <Panel header={record.pracownicy.length > 4 ? "Kierowane przez" + record.pracownicy.length + " pracowników" : "Kierowane przez " + record.pracownicy.length + " pracowników"} key="1">
                            <List
                                bordered
                                dataSource={record.pracownicy}
                               
                                renderItem={(item: any) => (
                                    
                                    <List.Item>
                                        Pracownik: {item.imie+ ' '+ item.nazwisko}, Adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> 
                                        , Numer telefonu: {item.numer_telefon}.
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
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
            title: 'Klienty',
            key: 'klienci',
            render: (text: any, record: any) =>
                <>{record.klienci.length > 0 ?

                    <Collapse >
                        <Panel header={record.klienci.length > 4 ? "Przepisano " + record.klienci.length + " klientów" : "Przepisano " + record.klienci.length + " klientów"} key="1">
                            <List
                                bordered
                                dataSource={record.klienci}
                               
                                renderItem={(item: any) => (
                                    
                                    <List.Item>
                                        Klient: {item.imie+' '+ item.nazwisko}, adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> 
                                        , Numer telefonu: {item.numer_telefonu}, Data urodzenia: {item.data_urodzenia}.
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
        },

        {
            title: 'Przewodnicy',
            key: 'przewodnicy',
            render: (text: any, record: any) =>
                <>{record.klienci.length > 0 ?

                    <Collapse >
                        <Panel header={record.przewodnicy.length > 4 ? "Jest pilotowana przez " + record.przewodnicy.length + " przewodników" : "Jest pilotowana przez " + record.przewodnicy.length + " przewodników"} key="1">
                            <List
                                bordered
                                dataSource={record.przewodnicy}
                               
                                renderItem={(item: any) => (
                                    
                                    <List.Item>
                                        Klient: {item.imie+' '+ item.nazwisko}, adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> 
                                        , Numer telefonu: {item.numer_telefonu}.
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
        },
        {
            title: 'Zakwaterowania',
            key: 'zakwaterowania',
            render: (text: any, record: any) =>
                <>{record.klienci.length > 0 ?

                    <Collapse >
                        <Panel header={record.zakwaterowania.length > 4 ? "Zakwaterowań używano " + record.zakwaterowania.length  : "Zakwaterowań używano  " + record.zakwaterowania.length } key="1">
                            <List
                                bordered
                                dataSource={record.zakwaterowania}
                               
                                renderItem={(item: any) => (
                                    
                                    <List.Item>
                                        Nazwa: {item.nazwa}, Koszt {item.koszt}, Ilość miejsc: {item.ilosc_miejsc}, Standard zakwaterowania: {item.standard_zakwaterowania}
                                        , Ilosc miejsc: {item.ilosc_miejsc}
                                        , adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> .
                                    </List.Item>
                                )}
                            />
                        </Panel>
                    </Collapse > :
                    <>Brak danych</>
                }</>
        },
        // {
        //     title: 'Etapy',
        //     key: 'etapy',
        //     render: (text: any, record: any) =>
        //         <>{record.etapy.length > 0 ?

        //             <Collapse >
        //                 <Panel header={record.etapy.length > 4 ? "Obsługuje " + record.etapy.length + " atracje" : "Obsługuje " + record.etapy.length + " atrakcje"} key="1">
        //                     <List
        //                         bordered
        //                         dataSource={record.etapy}
                               
        //                         renderItem={(item: any) => (
                                    
        //                             <List.Item>
        //                                 Nazwa: {item.nazwa}, adres: <a href={"https://www.google.com/maps/search/?api=1&query=" + item.adres.replace(' ', '+')}>{item.adres}</a> 
        //                                 , opis: {item.opis}, koszt: {item.koszt}.
        //                             </List.Item>
        //                         )}
        //                     />
        //                 </Panel>
        //             </Collapse > :
        //             <>Brak danych</>
        //         }</>
        // },
       
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
