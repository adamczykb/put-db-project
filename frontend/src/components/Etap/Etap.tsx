import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getEtapyData from "../../utils/adapter/getEtapyData";
import removeEtap from "../../utils/adapter/removeEtap";

const { Panel } = Collapse;

const EtapView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getEtapyData(setData)
    }, [])
    const columns = [
        {
            title: 'ID',
            key: 'id',
            render: (text: any, record: any) => <>{record.id}</>,
        },
        {
            title: 'Punkt poczatkowy',
            key: 'punkt_poczatkowy',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.punkt_poczatkowy.replace(' ', '+')}>{record.punkt_poczatkowy}</a>,
        },
        {
            title: 'Punkt konczowy',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.punkt_konczowy.replace(' ', '+')}>{record.punkt_konczowy}</a>,
            key: 'punkt_konczowy',
        },
        {
            title: 'Koszt',
            key: 'koszt',
            render: (text: any, record: any) => <>{record.koszt}</>,
        },
        {
            title: 'Data poczatkowa',
            key: 'data_poczatkowa',
            render: (text: any, record: any) => <>{record.data_poczatkowa}</>,
        },
        {
            title: 'Data koncowa',
            key: 'data_koncowa',
            render: (text: any, record: any) => <>{record.data_koncowa}</>,
        },
        {
            title: 'Transport',
            key: 'transport',
            render: (text: any, record: any) =>
                <>{record.transport.length > 0 ?

                    <Collapse >
                        <Panel header={record.transport.length > 4 ? "Używa " + record.transport.length + " jednostek" : "Używa " + record.transport.length + " jednostek"} key="1">
                            <List
                                bordered
                                dataSource={record.transport}
                                renderItem={(item: any) => (
                                    <List.Item>
                                        Nazwa: {item.nazwa}  
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
                <a href={"/etapy/edycja/" + record.id}>Edytuj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removeEtap(record.key)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Etapy</h2>
            <Space><Button type="primary" onClick={() => { window.open('/etapy/dodaj') }}>Dodaj etap</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default EtapView
