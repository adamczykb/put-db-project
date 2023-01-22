import AddClients from "../../components/home/AddClient";
import config from "../../config.json";

const addClients = (attraction_id: any, pilot_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { atrakcja_id: attraction_id, przewodnik_id: pilot_id } })
    };

    fetch(config.SERVER_URL + "/api/update/certain_client", requestOptions)
        .then((response) => response.json())
        .then((response) => {

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default addClients;