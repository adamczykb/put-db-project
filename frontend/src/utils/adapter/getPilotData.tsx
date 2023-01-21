import config from "../../config.json";

const getPilotData = (setData: any) => {
    const requestOptions = {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
    };
    fetch(config.SERVER_URL + "/api/get/all_pilots", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            setData(response.result);
        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default getPilotData;
