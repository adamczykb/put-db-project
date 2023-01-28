import { Button, Collapse, Input, List, Popconfirm, Space, Table, Tag, } from "antd"
import { useEffect, useRef, useState } from "react";
import getClientsData from "../../utils/adapter/getClientsData";
import removeClient from "../../utils/adapter/removeClient";
import { stringToDate } from "./UpdateClient";
const { Panel } = Collapse;
import { SearchOutlined } from '@ant-design/icons';
const ClientsView = () => {
    const [searchText, setSearchText] = useState('');
    const [searchedColumn, setSearchedColumn] = useState('');
    const handleSearch = (
        confirm: (param?: any) => void,
    ) => {
        confirm();
    };

    const handleReset = (clearFilters: () => void) => {
        clearFilters();
        setSearchText('');
    };

    const getColumnSearchProps = (dataIndex: any): any => ({
        filterDropdown: ({ setSelectedKeys, selectedKeys, confirm, clearFilters, close }: { setSelectedKeys: any, selectedKeys: any, confirm: any, clearFilters: any, close: any }) => (
            <div style={{ padding: 8 }} onKeyDown={(e) => e.stopPropagation()}>
                <Input
                    placeholder={`Search PDB ID`}
                    value={selectedKeys[0]}
                    onChange={(e) => setSelectedKeys(e.target.value ? [e.target.value] : [])}
                    onPressEnter={() => handleSearch(confirm)}
                    style={{ marginBottom: 8, display: 'block' }}
                />
                <div style={{ textAlign: 'right' }}>
                    <Space style={{ paddingTop: 10 }}>
                        <Button
                            onClick={() => handleReset(clearFilters)}
                            size="middle"
                        >
                            Reset
                        </Button>
                        <Button
                            type="primary"
                            onClick={() => handleSearch(confirm)}
                            icon={<SearchOutlined />}
                            size="middle"
                        >
                            Search
                        </Button>
                    </Space>
                </div>
            </div>
        ),
        filterIcon: (filtered: boolean) => (
            <SearchOutlined style={{ color: '#00a498' }} />
        ),
        onFilter: (value: any, record: any) =>
            record[dataIndex]
                .toString()
                .toLowerCase()
                .includes((value as string).toLowerCase()),
    });
    const [data, setData] = useState([]);
    useEffect(() => {
        getClientsData(setData)
    }, [])
    const columns = [
        {
            title: 'Pesel',
            key: 'pesel',
            render: (text: any, record: any) => <>{record.pesel}</>,
            sorter: (a: any, b: any) => a.pesel.localeCompare(b.pesel),
            ...getColumnSearchProps('pesel')
        },
        {
            title: 'Imie',
            key: 'imie',
            render: (text: any, record: any) => <>{record.imie}</>,
            sorter: (a: any, b: any) => a.imie.localeCompare(b.imie),
            ...getColumnSearchProps('imie')
        },
        {
            title: 'Nazwisko',
            key: 'nazwisko',
            render: (text: any, record: any) => <>{record.nazwisko}</>,
            sorter: (a: any, b: any) => a.nazwisko.localeCompare(b.nazwisko),
            ...getColumnSearchProps('nazwisko')
        },
        {
            title: 'Numer telefonu',
            key: 'telefon',
            render: (text: any, record: any) => <>{record.numer_telefonu}</>,
            sorter: (a: any, b: any) => a.numer_telefonu.localeCompare(b.numer_telefonu),
        },
        {
            title: 'Addres',
            render: (text: any, record: any) => <a href={"https://www.google.com/maps/search/?api=1&query=" + record.adres.replace(' ', '+')}>{record.adres}</a>,
            key: 'adres',
            sorter: (a: any, b: any) => a.adres.localeCompare(b.adres),
        },

        {
            title: 'Data_urodzenia',
            key: 'data_urodzenia',
            render: (text: any, record: any) => <>{record.data_urodzenia}</>,
            sorter: (a: any, b: any) => stringToDate(a.data_urodzenia.split(' ')[0], "yyyy-mm-dd", '-').getTime() - stringToDate(b.data_urodzenia.split(' ')[0], "yyyy-mm-dd", '-').getTime(),
        },

        {
            title: 'Numer telefonu',
            key: 'numer_telefonu',
            render: (text: any, record: any) => <>{record.numer_telefonu}</>,
            sorter: (a: any, b: any) => a.pesel.localeCompare(b.pesel),
        },
        {
            title: 'Podróże',
            key: 'podroze',
            render: (text: any, record: any) =>
                <>{record.podroze.length > 0 ?
                    <Collapse >
                        <Panel header={record.podroze.length > 1 ? "Uczestniczy w " + record.podroze.length + " podróżach" : "Uczestniczy w " + record.podroze.length + " podróży"} key="1">
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
                <a href={"/klienty/edycja/" + record.pesel}>Edytuj</a><br />
                <Popconfirm title="Potwierdź czy chcesz usunąć klienta" onConfirm={() => removeClient(record.pesel)}>
                    <a>Usuń</a>
                </Popconfirm>
            </>
        },
    ]
    return (
        <div>
            <h2>Klienci</h2>
            <Space><Button type="primary" onClick={() => { window.open('/klienty/dodaj', '_self') }}>Dodaj klienta</Button></Space>
            <br />
            <br />
            <Table columns={columns} dataSource={data} />
        </div>
    )
}
export default ClientsView
