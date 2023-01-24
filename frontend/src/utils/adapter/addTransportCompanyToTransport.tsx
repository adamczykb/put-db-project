import config from "../../config.json";

const addTransportCompanyToTransport = (language_kod: any, pilot_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { language_kod: language_kod, przewodnik_id: pilot_id } })
    };

    fetch(config.SERVER_URL + "/api/push/transport_company_transport", requestOptions)
        .then((response) => response.json())
        .then((response) => {

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default addTransportCompanyToTransport;
