import { message } from "antd";
import config from "../../config.json";

const removeJourney = (id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { id: id } })
    };

    fetch(config.SERVER_URL + "/api/delete/journey", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            if (response.status == 200) {
                message.success("Podróż została usunięta")
                window.open('/podrozy', '_self')
            } else {
                message.success("Wystąpił błąd podczas usuwania podróży, odśwież strone i spróbuj ponownie")
            }

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default removeJourney;
