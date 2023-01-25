import { message } from "antd";
import config from "../../config.json";

const removeLanguage = (id: any) => {
    const requestOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify({ params: { kod: id } })
    };

    fetch(config.SERVER_URL + "/api/delete/language", requestOptions)
        .then((response) => response.json())
        .then((response) => {
            if (response.status == 200) {
                message.success("Pracownik został usunięty")
                
                window.open('/jezyki', '_self');
                
            } else {
                message.success("Wystąpił błąd podczas usuwania języka, odśwież strone i spróbuj ponownie")
            }

        })
        .catch((error) => console.log('Błąd połączenia z serwerem'));
};

export default removeLanguage;
