import { Button, Collapse, List, Popconfirm, Space, Table, Tag, } from "antd"
import { useEffect, useState } from "react";
import getLanguagesData from "../../utils/adapter/getLanguageData";
import removeLanguage from "../../utils/adapter/removeLanguage";
const { Panel } = Collapse;

const LangView = () => {

    const [data, setData] = useState([]);
    useEffect(() => {
        getLanguagesData(setData)
    }, [])
    const columns = [
        {
            title: 'Kod',
            key: 'kod',
            render: (text: any, record: any) => <>{record.kod}</>,
        },
        {
            title: 'Język',
            key: 'nazwa',
            render: (text: any, record: any) => <>{record.nazwa}</>,
        },
        {
            title: 'Akcja',
            render: (text: any, record: any) => <>

                <Popconfirm title="Napewno usunąć język?" onConfirm={() => removeLanguage(record.kod)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Języki</h2>
            <Space><Button type="primary" onClick={() => { window.open('/jezyki/dodaj', '_Self') }}>Dodaj język</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default LangView
