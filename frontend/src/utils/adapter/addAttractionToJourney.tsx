import config from "../../config.json";

const addAttractionToJourney = (atrakcja_id: any, journey_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { atrakcja_id: atrakcja_id, podroz_id: journey_id } })
    };

    fetch(config.SERVER_URL + "/api/push/journey_attraction", requestOptions)
        .then((response) => response.json())
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default addAttractionToJourney;
