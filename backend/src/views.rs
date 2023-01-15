use crate::{urls::RequestBody, utils::get_postgres_client};
use serde::{Deserialize, Serialize};
use serde_json::{map::Values, Value};
use std::collections::HashMap;

pub fn http_response(params: HashMap<&str, String>) -> String {
    if params.get("Content-Type").unwrap_or(&"".to_owned()) == "" {
        return format!(
            "HTTP/1.1 {}\r\nContent-Length: {}\r\n\r\n{}",
            params.get("Status").unwrap(),
            params.get("Content").unwrap().len(),
            params.get("Content").unwrap()
        );
    } else {
        return format!(
            "HTTP/1.1 {}\r\nContent-Length: {}\r\nContent-Type:{}\r\n\r\n{}",
            params.get("Status").unwrap(),
            params.get("Content").unwrap().len(),
            params.get("Content-Type").unwrap_or(&"".to_owned()),
            params.get("Content").unwrap()
        );
    }
}
#[derive(Serialize, Deserialize)]
pub struct Response<T> {
    status: i32,
    message: String,
    result: Vec<T>,
}

#[derive(Serialize, Deserialize)]
pub struct Klient {
    pesel: i64,
    imie: String,
    nazwisko: String,
    adres: String,
    numer_telefonu: String,
    data_urodzenia: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct KlientQuery {
    pub pesel_list: Vec<i64>,
}

pub fn get_all_clients_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let  result: Response<Klient> = Response{
            status: 200,
            message: "Git".to_owned(),
            result: connection.query(
                    "select pesel,imie,nazwisko, adres,numer_telefonu,cast(data_urodzenia as varchar) from public.klient", &[]
                    ).unwrap().iter().map(|row| {
                        Klient{
                            pesel:row.get(0),
                            imie: row.get(1),
                            nazwisko: row.get(2),
                            adres: row.get(3),
                            numer_telefonu: row.get(4),
                            data_urodzenia: row.get(5)
                        }
                    }).collect::<Vec<Klient>>()
        };
        connection.close();
        return HashMap::from([
            ("Status", "200 OK".to_owned()),
            (
                "Content",
                serde_json::to_string(&result).unwrap().to_owned(),
            ),
            ("Content-Type", "application/json".to_owned()),
        ]);
    } else {
        println!("ERROR: Cannot connet to database!");
        return HashMap::from([
            ("Status", "401 PERMISSION DENIED".to_owned()),
            ("Content", "{result:'PERMISSION DENIED'}".to_owned()),
            ("Content-Type", "application/json".to_owned()),
        ]);
    }
}

pub fn get_certain_clients_json<'a>(params: RequestBody<KlientQuery>) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .pesel_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query:String = "select pesel,imie,nazwisko, adres,numer_telefonu,cast(data_urodzenia as varchar) from public.klient where pesel in (".to_owned() ;
    query.push_str(params_query.join(",").as_str());
    query.push_str(")");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<Klient> = Response {
            status: 200,
            message: "All right".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Klient {
                    pesel: row.get(0),
                    imie: row.get(1),
                    nazwisko: row.get(2),
                    adres: row.get(3),
                    numer_telefonu: row.get(4),
                    data_urodzenia: row.get(5),
                })
                .collect::<Vec<Klient>>(),
        };
        connection.close();
        return HashMap::from([
            ("Status", "200 OK".to_owned()),
            (
                "Content",
                serde_json::to_string(&result).unwrap().to_owned(),
            ),
            ("Content-Type", "application/json".to_owned()),
        ]);
    } else {
        println!("ERROR: Cannot connet to database!");
        return HashMap::from([
            ("Status", "401 PERMISSION DENIED".to_owned()),
            ("Content", "{result:'PERMISSION DENIED'}".to_owned()),
            ("Content-Type", "application/json".to_owned()),
        ]);
    }
}

pub fn get_update_client_json<'a>(content: String) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let mut result: Response<Klient>;
    if client.is_ok() {
        let mut connection = client.unwrap();
        if connection.execute(
                    "INSERT INTO klient (pesel,imie,nazwisko, adres,numer_telefonu,data_urodzenia) values ($1,$2,$3,$4,$5,$6)", &[]
        ).is_ok(){
               result= Response{
            status: 200,
            message: "All right".to_owned(),
            result:Vec::new()
        };
        }else{
               result= Response{
            status: 500,
            message: "Cannot insert new klient".to_owned(),
            result:Vec::new()
        };
        }
        connection.close();
        return HashMap::from([
            ("Status", result.status.to_string()),
            (
                "Content",
                serde_json::to_string(&result).unwrap().to_owned(),
            ),
            ("Content-Type", "application/json".to_owned()),
        ]);
    } else {
        println!("ERROR: Cannot connet to database!");
        return HashMap::from([
            ("Status", "401 PERMISSION DENIED".to_owned()),
            ("Content", "{result:'PERMISSION DENIED'}".to_owned()),
            ("Content-Type", "application/json".to_owned()),
        ]);
    }
}
