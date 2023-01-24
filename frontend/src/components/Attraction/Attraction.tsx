import { render } from "@testing-library/react";
import { Collapse, List, Popconfirm, Table, Tag, } from "antd"
import { useEffect, useState } from "react";
import { text } from "stream/consumers";
import getAttraction from "../../utils/adapter/getAttractionData";
import removeAttraction from "../../utils/adapter/removeAttraction";

const { Panel } = Collapse;

const AttractionView = () => {
    const handleDelete = (key: React.Key) => {

    };

    const [data, setData] = useState([]);
    useEffect(() => {
        getAttraction(setData)
    }, [])
    const columns = [
        { 
            title: 'Nazwa',
            key: 'nazwa, adres, sezon, opis,koszt',
            render: (text: any, record: any) => <>{record.nazwa}</>,
        },
       
        
        {
            title: 'Adres',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'adres',
        },
        
        { 
            title: 'Sezon',
            key: 'sezon',
            render: (text: any, record: any) => <>{record.sezon}</>,
        },

        {
            title: 'Przewodnicy',
            key: 'przewodnicy',
            render: (text: any, record: any) =>
                <>{record.przewodnicy.length > 0 ?
                    <Collapse >
                        <Panel header={record.przewodnicy.length > 4 ? "Przepisano " + record.przewodnicy.length + " przewodnikow" : "Przepisano " + record.przewodnicy.length + " przewodnikow"} key="1">
                            <List
                                bordered
                                dataSource={record.przewodnicy}
                                renderItem={(item: any) => (
                                    <List.Item>
                                        {item.imie}, {item.nazwisko}
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
                <a href={"/atrakcje/edycja/" + record.id}>Edytuj</a><br />
                <a href={"/atrakcje/dodaj/"}>dodaj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removeAttraction(record.id)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Atrakcje</h2>
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default AttractionView
