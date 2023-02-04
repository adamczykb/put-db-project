import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getTransportData from "../../utils/adapter/getTransportData";

import removeTransport from "../../utils/adapter/removeTransport";
import removeTransportNew from "../../utils/adapter/removeTransportNew";
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

        {
            title: 'Firma transportowa',
            key: 'firmy_transportowe',
            render: (text: any, record: any) =>
                <>{record.firmy_transportowe.length > 0 ?
                    <Collapse >
                        <Panel header={"Przypisano firm " + record.firmy_transportowe.length} key="1">
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
                    <>Brak powiązań</>

                }</>
        },

        {
            title: 'Akcja',
            render: (text: any, record: any) => <>

                <a href={"/transport/edycja/" + record.id}>Edytuj</a><br />
                <Popconfirm title="Napewno chcesz usunąć transport?" onConfirm={() => removeTransportNew(record.key)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Transporty</h2>
            <Space><Button type="primary" onClick={() => { window.open('/transport/dodaj', '_self') }}>Dodaj transport</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default TransportyView
