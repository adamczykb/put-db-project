import { message } from "antd";
import config from "../../config.json";

const removeClient = (id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { pesel: id } })
    };

    fetch(config.SERVER_URL + "/api/delete/client", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            if (response.status == 200) {
                message.success("Client został usunięty")
                window.open('/klienty', '_self')
            } else {
                message.success("Wystąpił błąd podczas usuwania przewodnika, odśwież strone i spróbuj ponownie")
            }

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default removeClient;