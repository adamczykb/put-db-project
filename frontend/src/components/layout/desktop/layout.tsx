import React, { useState } from 'react';
import {
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  UploadOutlined,
  UserOutlined,
  VideoCameraOutlined,
} from '@ant-design/icons';
import { Layout, Menu, theme } from 'antd';
import IndexRouter from '../../../routes/router';
const { Header, Sider, Content } = Layout;

const Frontend: React.FC = () => {
  const [collapsed, setCollapsed] = useState(false);
  const {
    token: { colorBgContainer },
  } = theme.useToken();

  return (
    <Layout>
      <Sider trigger={null} collapsible collapsed={collapsed}>
        <div className="logo" />
        <Menu
          theme="dark"
          mode="inline"
          defaultSelectedKeys={['1']}
          items={[
            {
              key: '1',
              icon: <UserOutlined />,
              label: (
              <a href="/klienty">
                Klienty
                </a>
                ),
            },
            {
              key: '2',
              icon: <VideoCameraOutlined />,
              label: (<a href="/podrozy">
                
                  Podróży
              </a>),
            },
            {
              key: '3',
              icon: <UserOutlined />,
              label: (<a href="/pracowniki">
                Informację o pracownikach
              </a>),
            },
          ]}
        />
      </Sider>
      <Layout className="site-layout">
        <Header style={{ padding: 0, background: colorBgContainer }}>
          {React.createElement(collapsed ? MenuUnfoldOutlined : MenuFoldOutlined, {
            className: 'trigger',
            onClick: () => setCollapsed(!collapsed),
          })}
        </Header>
        <Content
          style={{
            margin: '24px 16px',
            padding: 24,
            minHeight: 280,
            background: colorBgContainer,
          }}
        >
         
          <IndexRouter/>
          
        </Content>
      </Layout>
    </Layout>
  );
};

export default Frontend;