import config from "../../config.json";

const getCertainPilot = (id: any, setData: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { id_list: [Number(id)] } })
    };
    fetch(config.SERVER_URL + "/api/get/certain_pilots", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            setData(response.result[0]);
        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default getCertainPilot;
