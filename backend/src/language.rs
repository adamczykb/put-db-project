use crate::{
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Jezyk {
    pub key: String,
    pub kod: String,
    pub nazwa: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct JezykBasic {
    pub kod: String,
    pub nazwa: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct JezykDelete {
    pub kod: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct JezykQuery {
    pub kody: Vec<String>,
}
pub fn get_all_languages_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Jezyk> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query("select  kod, nazwa from jezyk order by kod", &[])
                .unwrap()
                .iter()
                .map(|row| Jezyk {
                    key: row.get(0),
                    kod: row.get(0),
                    nazwa: row.get(1),
                })
                .collect::<Vec<Jezyk>>(),
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

pub fn get_certain_languages_json<'a>(params: RequestBody<JezykQuery>) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params.params.kody.iter().map(|v| v.to_string()).collect();
    let mut query: String = "select kod, nazwa from jezyk where kod in (".to_owned();
    query.push_str(params_query.join(",").as_str());
    query.push_str(") order by kod");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Jezyk> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Jezyk {
                    key: row.get(0),
                    kod: row.get(0),
                    nazwa: row.get(1),
                })
                .collect::<Vec<Jezyk>>(),
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

pub fn insert_certain_language_json<'a>(
    params: RequestBody<JezykBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "INSERT INTO jezyk (kod, nazwa) values (upper($1),$2)",
                &[&params.params.kod, &params.params.nazwa],
            )
            .unwrap_or(0);

        if query_result > 0 {
            result = Response {
                status: 200,
                message: "OK".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Cannot add new language".to_owned(),
                result: query_result,
            };
        }
        let mut response = HashMap::from([
            (
                "Content",
                serde_json::to_string(&result).unwrap().to_owned(),
            ),
            ("Content-Type", "application/json".to_owned()),
        ]);
        if result.status == 200 {
            response.extend([("Status", "200 OK".to_owned())]);
        } else {
            response.extend([("Status", "500 Internal Server Error".to_owned())]);
        }
        connection.close();
        return response;
    } else {
        println!("ERROR: Cannot connect to database!");
        return HashMap::from([
            ("Status", "401 PERMISSION DENIED".to_owned()),
            ("Content", "{result:'PERMISSION DENIED'}".to_owned()),
            ("Content-Type", "application/json".to_owned()),
        ]);
    }
}

pub fn delete_certain_language_json<'a>(
    params: RequestBody<JezykDelete>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        connection
            .execute(
                "Delete from jezyk_pracownik where jezyk_kod=$1",
                &[&params.params.kod],
            )
            .unwrap_or(0);
        connection
            .execute(
                "Delete from jezyk_przewodnik where jezyk_kod=$1",
                &[&params.params.kod],
            )
            .unwrap_or(0);
        let query_result = connection
            .execute("Delete from jezyk where kod=$1", &[&params.params.kod])
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Jezyk usuniety".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Nie mozna usunac jezyka".to_owned(),
                result: query_result,
            };
        }
        let mut response = HashMap::from([
            (
                "Content",
                serde_json::to_string(&result).unwrap().to_owned(),
            ),
            ("Content-Type", "application/json".to_owned()),
        ]);
        if result.status == 200 {
            response.extend([("Status", "200 OK".to_owned())]);
        } else {
            response.extend([("Status", "500 Internal Server Error".to_owned())]);
        }
        connection.close();
        return response;
    } else {
        println!("ERROR: Cannot connet to database!");
        return HashMap::from([
            ("Status", "401 PERMISSION DENIED".to_owned()),
            ("Content", "{result:'PERMISSION DENIED'}".to_owned()),
            ("Content-Type", "application/json".to_owned()),
        ]);
    }
}
