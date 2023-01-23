import { Collapse, List, Popconfirm, Table, Tag, Space, Button } from "antd"
import { useEffect, useState } from "react";
import getTransportCompanyData from "../../utils/adapter/getTransportCompanyData";

import removePilot from "../../utils/adapter/removePilot";
import removeTransportCompany from "../../utils/adapter/removeTransportCompany";
const { Panel } = Collapse;

const TransportCompanyView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getTransportCompanyData(setData)
    }, [])
    const columns = [
        {
            title: 'Nazwa',
            key: 'nazwa',
            render: (text: any, record: any) => <>{record.nazwa}</>,
        },
        {
            title: 'Numer telefonu',
            key: 'telefon',
            render: (text: any, record: any) => <>{record.telefon}</>,
        },
        {
            title: 'Adres',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'adres',
        },
        
        {
            title: 'Akcja',
            render: (text: any, record: any) => <>
                <a href={"/firma_transportowa/edycja/" + record.id}>Edytuj</a><br />
                <Popconfirm title="Sure to delete?" onConfirm={() => removeTransportCompany(record.key)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Firma transportowa</h2>
            <Space><Button type="primary" onClick={() => { window.open('/firma_transportowa/dodaj') }}>Dodaj firmę transportową</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default TransportCompanyView
