import { message } from "antd";
import config from "../../config.json";

const getCertainAccommodation = (id: any, setData: any) => {
    const requestOptions = {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { id_list: [id] } })
    };
    fetch(config.SERVER_URL + "/api/get/certain_accommodation", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            if (response.status == 200 && response.result.length > 0) {
                setData(response.result[0]);
            } else {
                message.error("Takie zakwaterowanie nie istnieje")
                setTimeout(function () {
                    window.open('/klienty', '_self')
                }, 2.0 * 1000);

            }
        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default getCertainAccommodation;
