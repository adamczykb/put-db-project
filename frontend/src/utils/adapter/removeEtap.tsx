import { message } from "antd";
import config from "../../config.json";

const removeEtap = (id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { pesel: id } })
    };

    fetch(config.SERVER_URL + "/api/delete/etap", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            if (response.status == 200) {
                message.success("Etap został usunięty")
                window.open('/etapy', '_self')
            } else {
                message.success("Wystąpił błąd podczas usuwania etapu, odśwież strone i spróbuj ponownie")
            }

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default removeEtap;