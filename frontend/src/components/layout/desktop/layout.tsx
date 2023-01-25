import React, { useState } from 'react';
import {
    MenuFoldOutlined,
    MenuUnfoldOutlined,
    UploadOutlined,
    CompassOutlined,
    UserOutlined, FolderViewOutlined,
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
                <div className="slider-logo" >Biuro <i>"Horus"</i></div>
                <Menu
                    theme="dark"
                    mode="inline"
                    items={[
                        {
                            key: '10',
                            icon: <FolderViewOutlined/>,
                            label: (<a href='/podrozy'>
                                Podróże
                            </a>)
                        },
                        
                        {
                            key: '1',
                            icon: <UserOutlined />,
                            label: (
                                <a href="/klienty">
                                    Klienci
                                </a>
                            ),
                        },

                        {
                            key: '3',
                            icon: <UserOutlined />,
                            label: (<a href="/pracownicy">
                                Pracownicy
                            </a>),
                        }, 
                        {
                            key: '4',
                            icon: <FolderViewOutlined />,
                            label: (<a href="/przewodnicy">
                                Przewodnicy
                            </a>),
                        },
                        {
                            key: '5',
                            icon: <FolderViewOutlined />,
                            label: (<a href="/zakwaterowanie">
                                Zakwaterowanie
                            </a>),
                        },
                        {
                            key: '6',
                            icon: <FolderViewOutlined/>,
                            label: (<a href='/firma_transportowa'>
                                Firma transportowa
                            </a>)
                        },
                        {
                            key: '7',
                            icon: <FolderViewOutlined/>,
                            label: (<a href='/transporty'>
                                Transport
                            </a>)
                        },
                        {
                            key: '8',
                            icon: <FolderViewOutlined/>,
                            label: (<a href='/atrakcje'>
                                Atrakcje
                            </a>)
                        },
                        {
                            key: '9',
                            icon: <FolderViewOutlined/>,
                            label: (<a href='/etapy'>
                                Etapy
                            </a>)
                        },
                        
                        {
                            key: '11',
                            icon: <FolderViewOutlined/>,
                            label: (<a href='/jezyki'>
                                Języki
                            </a>)
                        }

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

                    <IndexRouter />

                </Content>
            </Layout>
        </Layout>
    );
};

export default Frontend;
