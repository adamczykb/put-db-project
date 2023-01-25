import config from "../../config.json";

const addEtapToJourney = (id: any, journey_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { etap_id: id, podroz_id: journey_id } })
    };

    fetch(config.SERVER_URL + "/api/push/journey_etap", requestOptions)
        .then((response) => response.json())
        .then((response) => {

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default addEtapToJourney;
