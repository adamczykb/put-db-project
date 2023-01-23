import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getEmployeeData from "../../utils/adapter/getEmployeeData";
import getPilotData from "../../utils/adapter/getPilotData";
import removePilot from "../../utils/adapter/removePilot";
const { Panel } = Collapse;

const WorkerView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getEmployeeData(setData)
    }, [])
    const columns = [
        {
            title: 'Pracownik',
            key: 'pilot',
            render: (text: any, record: any) => <>{record.imie + ' ' + record.nazwisko}</>,
        },
        {
            title: 'Numer telefonu',
            key: 'telefon',
            render: (text: any, record: any) => <>{record.numer_telefon}</>,
        },
        {
            title: 'Adres',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'addres',
        },
        {
            title: 'Znane języki',
            render: (text: any, record: any) =>
                <>{record.jezyki.length > 0 ? <>{record.jezyki.map((value: any) => <Tag>{value.nazwa}</Tag>)}</> : <>Brak danych</>}</>
        },
        // {
        //     title: 'Podróże',
        //     key: 'podroze',
        //     render: (text: any, record: any) =>
        //         <>{record.podroze.length > 0 ?
        //             <Collapse >
        //                 <Panel header={record.podroze.length > 4 ? "Obsługuje " + record.podroze.length + " podróże" : "Obsługuje " + record.podroze.length + " podróży"} key="1">
        //                     <List
        //                         bordered
        //                         dataSource={record.podroze}
        //                         renderItem={(item: any) => (
        //                             <List.Item>
        //                                 {item.nazwa}
        //                             </List.Item>
        //                         )}
        //                     />
        //                 </Panel>
        //             </Collapse >
        //             :
        //             <>Brak danych</>

        //         }</>
        // },
        {
            title: 'Akcja',
            render: (text: any, record: any) => <>
                <a href={"/przewodnicy/edycja/" + record.id}>Edytuj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removePilot(record.key)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Pracownicy</h2>
            <Space><Button type="primary" onClick={() => { window.open('/pracownicy/dodaj') }}>Dodaj pracownika</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default WorkerView
