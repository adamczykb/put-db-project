import { message } from "antd";
import config from "../../config.json";

const addTransportCompanyToTransport = (id: any, transport_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { firma_transportowa_id: transport_id, transport_id: id} })
    };
    fetch(config.SERVER_URL + "/api/push/transport_company_transport", requestOptions)
        .then((response) => response.json())

        .catch((error) => message.error('Błąd połączenia z serwerem'));
};

export default addTransportCompanyToTransport;
