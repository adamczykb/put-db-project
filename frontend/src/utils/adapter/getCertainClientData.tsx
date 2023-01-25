import config from "../../config.json";

const getCertainClient = (pesel: any, setData: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { pesel_list: [pesel] } })
    };
    fetch(config.SERVER_URL + "/api/get/certain_clients", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            setData(response.result[0]);
        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default getCertainClient;
