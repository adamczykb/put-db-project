import config from "../../config.json";

const addWorkerToJourney = (id: any, journey_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { pracownik_id: id, podroz_id: journey_id } })
    };

    fetch(config.SERVER_URL + "/api/push/journey_worker", requestOptions)
        .then((response) => response.json())
        .then((response) => {

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default addWorkerToJourney;
