import { Button, Form, Input, InputNumber, message, Select, Table, Tag } from "antd";
import { useEffect, useState } from "react";
import getAllAttractions from "../../utils/adapter/getAllAttractions";
import getAllLanguages from "../../utils/adapter/getAllLanguages";

import config from '../../config.json'
import addAttractionToPilot from "../../utils/adapter/addAttractionToPilot";
import addLanguageToPilot from "../../utils/adapter/addLanguageToPilot";
import addLanguageToWorker from "../../utils/adapter/addLanguageToWorker";
import type { CustomTagProps } from 'rc-select/lib/BaseSelect';
const options = [{ value: 'zima' }, { value: 'lato' }, { value: 'wiosna' }, { value: 'jesień' }];

const tagRender = (props: CustomTagProps) => {
    const { label, value, closable, onClose } = props;
    const onPreventMouseDown = (event: React.MouseEvent<HTMLSpanElement>) => {
        event.preventDefault();
        event.stopPropagation();
    };
    return (
        <Tag
            
            onMouseDown={onPreventMouseDown}
            closable={closable}
            onClose={onClose}
            style={{ marginRight: 3 }}
        >
            {label}
        </Tag>
    );
};
const onFinish = (values: any) => {
};
// const attraction_columns = [
//     {
//         title: 'Atrakcja',
//         key: 'atrakcja',
//         render: (text: any, record: any) => <>{record.nazwa}</>,
//     },
//     {
//         title: 'Adres',
//         key: 'adres',
//         render: (text: any, record: any) => <>{record.adres}</>,
//     },
//     {
//         title: 'Opis',
//         key: 'opis',
//         render: (text: any, record: any) => <>{record.opis}</>,
//     },
// ]

const tailFormItemLayout = {
    wrapperCol: {
        xs: {
            span: 24,
            offset: 0,
        },
        sm: {
            span: 16,
            offset: 8,
        },
    },
};
const formItemLayout = {
    labelCol: {
        xs: { span: 24 },
        sm: { span: 8 },
    },
    wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
    },
};
const AddAttraction = () => {
    const [form] = Form.useForm();



    // const [selectedLanguagesKeys, setSelectedLanguagesKeys] = useState<React.Key[]>([]);
    // const [languagesData, setLanguagesData] = useState();
    // const onSelectLanguagesChange = (newSelectedRowKeys: React.Key[]) => {
    //     console.log('selectedRowKeys changed: ', newSelectedRowKeys);
    //     setSelectedLanguagesKeys(newSelectedRowKeys);
    // };
    // const rowLanguagesSelection = {
    //     selectedLanguagesKeys,
    //     onChange: onSelectLanguagesChange,
    // };

    // useEffect(() => {
    //     //getAllLanguages(setLanguagesData)
    // }, [])

    const onFinish = (values: any) => {
        

        //values.koszt=values.koszt.split(' ')
        const requestOptions = {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            body: JSON.stringify({ params: values })
        };

        fetch(config.SERVER_URL + "/api/push/attraction", requestOptions)
            .then((response) => response.json())
            .then((response) => {
                if (response.status == 200) {
                    // selectedLanguagesKeys.map((value: any) => {
                    //     addLanguageToWorker(value, response.result)
                    // })
                    console.log(response)
                    setTimeout(function () {
                        window.open('/atrakcje', '_self')
                    }, 2.0 * 1000);
                } else {
                    message.error("Wystąpił błąd podczas dodawania atrakcji, odśwież strone i spróbuj ponownie")
                }

            }).then(() => {
                if (message.error.length == 0) {
                    window.open('/atrakcje')
                }
            })
            .catch((error) => message.error('Błąd połączenia z serwerem'));
    };
    return <>
        <h2>Dodawanie nowej atrakcji</h2>
        <Form
            form={form}
            {...formItemLayout}
            name="add_pilto"
            onFinish={onFinish}
            style={{ maxWidth: 1200 }}
            scrollToFirstError
        >

            <Form.Item
                name="nazwa"
                label="Nazwa"
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwa nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
                name="adres"
                label="Adres"
                rules={[
                    {
                        required: true,
                        message: 'Pole nazwisko nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            <Form.Item
            name="sezon"
            label="Sezon"
            >
            <Select
                mode="multiple"
                showArrow
                tagRender={tagRender}
              
                style={{ width: '100%' }}
                options={options}
            />
            </Form.Item>
            <Form.Item
                name="opis"
                label="Opis"
                rules={[
                    {
                        required: true,
                        message: 'Pole opis nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item>
            
            
            {/* <Form.Item
                name="sezon"
                label="Sezon"
                rules={[
                    {
                        required: true,
                        message: 'Pole adres nie może być puste!',
                    },
                ]}
            >
                <Input />
            </Form.Item> */}

            <Form.Item
                name="koszt"
                label="Koszt"
                rules={[
                    {
                        required: true,
                        message: 'Pole koszt nie może być puste!',
                    },
                    {
                        validator: (rule, value) => {
                            if (value <= 0) {
                                return Promise.reject('Koszt musi być większy niż 0');
                            }
                            return Promise.resolve();
                        },
                    }
                ]}
            >
                <InputNumber />
            </Form.Item>
            
            {/* <Form.Item
                label="Powiązany z atrakcjami"
            >
                <Table
                    rowSelection={rowAttractionSelection}
                    columns={attraction_columns}
                    dataSource={attractionData}
                />
            </Form.Item> */}
            {/* <Form.Item
                label="Zna języki"
            >
                <Table
                    rowSelection={rowLanguagesSelection}
                    columns={languages_columns}
                    dataSource={languagesData}
                />
            </Form.Item> */}

            <Form.Item {...tailFormItemLayout}>
                <Button type="primary" htmlType="submit">
                    Dodaj pracownika
                </Button>
            </Form.Item>
        </Form>
    </>
}
export default AddAttraction;
