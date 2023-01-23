import config from "../../config.json";

const addLanguageToWorker = (language_kod: any, pracownik_id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { pracownik_id: pracownik_id,  language_kod: language_kod } })
    };

    fetch(config.SERVER_URL + "/api/push/worker_language", requestOptions)
        .then((response) => response.json())
        .then((response) => {

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default addLanguageToWorker;