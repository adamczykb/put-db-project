import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getTransportData from "../../utils/adapter/getTransportData";

import removeTransport from "../../utils/adapter/removeTransport";
const { Panel } = Collapse;

const TransportyView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getTransportData(setData)
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
       //
        {
            title: 'Firma transportowa',
            key: 'firmy_transportowe',
            render: (text: any, record: any) =>
                <>{record.firmy_transportowe.length > 0 ?
                    <Collapse >
                        <Panel header={record.firmy_transportowe.length > 4 ? "Obsługuje " + record.firmy_transportowe.length + " podróże" : "Obsługuje " + record.firmy_transportowe.length + " podróży"} key="1">
                            <List
                                bordered
                                dataSource={record.firmy_transportowe}
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

        // {
        //     title: 'Akcja',
        //     render: (text: any, record: any) => <>
            
        //         <Popconfirm title="Sure to delete?" onConfirm={() => removeTransport(record.key)}>
        //             <a>Usuń</a>
        //         </Popconfirm>
        //     </>
        // },
    ]
    return (
        <div>
            <h2>Transporty dla etapów</h2>
            {/* <Space><Button type="primary" onClick={() => { window.open('/transporty/dodaj') }}>Dodaj transport</Button></Space> */}
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default TransportyView
