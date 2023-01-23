import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getPilotData from "../../utils/adapter/getPilotData";
import removePilot from "../../utils/adapter/removePilot";
const { Panel } = Collapse;

const TransportyView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getPilotData(setData)
    }, [])
    const columns = [
        {
            title: 'Nazwa',
            key: 'nazwa',
            render: (text: any, record: any) => <>{record.nazwa}</>,
        },
        {
            title: 'Liczba jednostek',
            key: 'liczba_jednostek',
            render: (text: any, record: any) => <>{record.liczba_jednostek}</>,
        },
        {
            title: 'Liczba miejsc',
            key: 'liczba_miejsc',
            render: (text: any, record: any) => <>{record.liczba_miejsc}</>,
        },
       
        
        {
            title: 'Akcja',
            render: (text: any, record: any) => <>
                <a href={"/transporty/edycja/" + record.id}>Edytuj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removePilot(record.key)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Transport</h2>
            <Space><Button type="primary" onClick={() => { window.open('/transporty/dodaj') }}>Dodaj transport</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default TransportyView
