import {useEffect} from "react";

import React, { useState } from 'react';
import {
  AutoComplete,
  Button,
  Cascader,
  Checkbox,
  Col,
  Form,
  Input,
  InputNumber,
  Row,
  Select,
  DatePicker
} from 'antd';
import axios from "axios";

const { Option } = Select;

const residences = [
  {
    value: 'zhejiang',
    label: 'Zhejiang',
    children: [
      {
        value: 'hangzhou',
        label: 'Hangzhou',
        children: [
          {
            value: 'xihu',
            label: 'West Lake',
          },
        ],
      },
    ],
  },
  {
    value: 'jiangsu',
    label: 'Jiangsu',
    children: [
      {
        value: 'nanjing',
        label: 'Nanjing',
        children: [
          {
            value: 'zhonghuamen',
            label: 'Zhong Hua Men',
          },
        ],
      },
    ],
  },
];

const config = {
  rules: [{ type: 'object' as const, required: true, message: 'Proszę wprowadzić date urodzenia!' }],
};

const formItemLayout = {
  labelCol: {
    xs: { span: 24 },
    sm: { span: 8 },
  },
  wrapperCol: {
    xs: { span: 2 },
    sm: { span: 13},
  },
};
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

const rangeConfig = {
  rules: [{ type: 'array' as const, required: true, message: 'Proszę wybrać termin!' }],
};
const Sub = () => {
  const form = Form.useFormInstance();

  return <Button onClick={() => form.setFieldsValue({})} />;
};
const { RangePicker } = DatePicker;






const ClientForm: React.FC = () => {
  
  const [form] = Form.useForm();
  const [open, setOpen] = useState(false);

  const sendDataToApi = ( data: any) => {
    return axios({
      method: "POST",
      url: "http://localhost:8080/api/push/client",
      data: data,
    });
  };
//   const onSubmit = (data: any) => {
//     if ()  {

//     } 
//     sendDataToApi(data)
  
//  }
// ...fieldsValue,
      // 'data_urodzenia': fieldsValue['data_urodzenia'].format('DD-MM-YYYY'),
  const onFinish = (fieldsValue: any) => {
    // Should format date value before submit.
    const values = {
      "params":{...fieldsValue,'data_urodzenia': fieldsValue['data_urodzenia'].format('DD-MM-YYYY')},
      

    };
    console.log('Received values of form:', values);
    sendDataToApi(values);
  };

  const prefixSelector = (
    <Form.Item name="prefix" noStyle
    rules={
      [
        {
          required: true,
          message: 'Proszę wprowadzić prefix!'
        }
      ]
    }>
      <Select style={{ width: 70 }}>
        <Option value="48">+48</Option>
      </Select>
    </Form.Item>
  );


  const [autoCompleteResult, setAutoCompleteResult] = useState<string[]>([]);

  const onWebsiteChange = (value: string) => {
    if (!value) {
      setAutoCompleteResult([]);
    } else {
      setAutoCompleteResult(['.com', '.org', '.net'].map((domain) => `${value}${domain}`));
    }
  };

  

  // const websiteOptions = autoCompleteResult.map((website) => ({
  //   label: website,
  //   value: website,
  // }));
  
  return (
    <Form 
      {...formItemLayout}
      form={form}
      name="register"
      onFinish={onFinish} autoComplete="off"
      // initialValues={{
      //   residence: ['zhejiang', 'hangzhou', 'xihu'],
      //   prefix: '48',
      // }}

      scrollToFirstError
    >

      <Form.Item 
        name="pesel"
        label="Pesel"
        
        rules={
          [
          
            {
              
              required: true,
              message: 'Proszę wprowadzić nazwę'
            }
          ]
        }
        hasFeedback
      >
        <InputNumber type="number"/>
      </Form.Item>
      
      <Form.Item
        name="imie"
        label="Imię"
        rules={
          [
            {
              
              required: true,
              message: 'Proszę wprowadzić imię'
            }
          ]
        }
        hasFeedback
      >
        <Input />
      </Form.Item>
        
      <Form.Item
        name="nazwisko"
        label="Nazwisko"
        rules={
          [
            {
              
              required: true,
              message: 'Proszę wprowadzić nazwisko'
            }
          ]
        }
        hasFeedback
      >
        <Input />
      </Form.Item>

      <Form.Item
        name="numer_telefonu"
        label="Numer telefonu"
        rules={[{required: true, message: 'Proszę wprowadzić numer telefonu!' }]}
      >
        <Input style={{ width: '100%' }} />
      </Form.Item>
      
      <Form.Item
        name="adres"
        label="Adres"
        rules={
          [
            {
              
              required: true,
              message: 'Proszę wprowadzić adres'
            }
          ]
        }
        hasFeedback
      >
        <Input />
      </Form.Item>

      <Form.Item name="data_urodzenia" label="Data urodzenia" {...config}>
        <DatePicker />
      </Form.Item>
      


      <Form.Item {...tailFormItemLayout}>
        <Button  type="primary" htmlType="submit" >
          Dodaj podróż
          
        </Button>
        
      </Form.Item>
     
      
    </Form>
  );
};

export default ClientForm;