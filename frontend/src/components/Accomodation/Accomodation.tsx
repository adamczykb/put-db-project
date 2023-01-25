import { render } from "@testing-library/react";
import { Collapse, List, Popconfirm, Table, Tag, } from "antd"
import { useEffect, useState } from "react";
import { text } from "stream/consumers";
import getAccomodationData from "../../utils/adapter/getAccomodationData";
import removeAccommodation from "../../utils/adapter/removeAccomodation";
const { Panel } = Collapse;

const AccomodationView = () => {
    const handleDelete = (key: React.Key) => {

    };

    const [data, setData] = useState([]);
    useEffect(() => {
        getAccomodationData(setData)
    }, [])
    const columns = [
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
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'adres',
        },


        {
            title: 'Podróże',
            key: 'podroze',
            render: (text: any, record: any) =>
                <>{record.podroze.length > 0 ?
                    <Collapse >
                        <Panel header={record.podroze.length > 4 ? "Przepisano " + record.podroze.length + " podróżom" : "Przepisano " + record.podroze.length + " podróżom"} key="1">
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
                
                <a href={"/zakwaterowanie/dodaj/"}>dodaj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removeAccommodation(record.id)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Zakwaterowanie</h2>
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default AccomodationView
