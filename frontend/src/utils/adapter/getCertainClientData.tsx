import { message } from "antd";
import config from "../../config.json";

const getCertainClient = (pesel: any, setData: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { pesel_list: [pesel] } })
    };
    fetch(config.SERVER_URL + "/api/get/certain_clients", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            if (response.status == 200 && response.result.length > 0) {
                setData(response.result[0]);
            } else {
                message.error("Taki klient nie istnieje")
                setTimeout(function () {
                    window.open('/klienty', '_self')
                }, 2.0 * 1000);

            }
        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default getCertainClient;
