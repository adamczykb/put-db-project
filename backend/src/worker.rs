use crate::{
    language::{Jezyk, JezykBasic},
    pilot::PilotDeleteQuery,
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Worker {
    pub key: i64,
    pub id: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefon: String,
    pub jezyki: Vec<JezykBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct WorkerBasic {
    pub id: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefon: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct WorkerInsert {
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefon: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct WorkerLanguageQuery {
    pub pracownik_id: i64,
    pub language_kod: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct WorkerQuery {
    pub id_list: Vec<i64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct WorkerDeleteQuery {
    pub id: i64,
}

pub fn get_all_workers_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let  result: ResponseArray<Worker> = ResponseArray{
            status: 200,
            message: "OK".to_owned(),
            result: connection.query(
                    "select  p.id,p.imie,p.nazwisko,p.adres,p.numer_telefon, json_agg(j)::text as jezyki from pracownik p left join jezyk_pracownik jp on jp.pracownik_id=p.id left join jezyk j on j.kod=jp.jezyk_kod group by p.id,p.imie,p.nazwisko,p.adres,p.numer_telefon order by p.nazwisko", &[]
                    ).unwrap().iter().map(|row| {
                        Worker{
                    key: row.get(0),
                            id:row.get(0),
                            imie: row.get(1),
                            nazwisko:row.get(2),
                            adres: row.get(3),
                            numer_telefon: row.get(4),
                            jezyki: serde_json::from_str::<Vec<JezykBasic>>(row.get(5)  ).unwrap_or(Vec::new())
                        }
            }).collect::<Vec<Worker>>()
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

pub fn get_certain_workers_json<'a>(params: RequestBody<WorkerQuery>) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .id_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query:String = "select  p.id,p.imie,p.nazwisko,p.adres,p.numer_telefon, json_agg(j)::text as jezyki from pracownik p left join jezyk_pracownik jp on jp.pracownik_id=p.id left join jezyk j on j.kod=jp.jezyk_kod where p.id in (".to_owned() ;
    query.push_str(params_query.join(",").as_str());
    query
        .push_str(") group by p.id,p.imie,p.nazwisko,p.adres,p.numer_telefon  order by p.nazwisko");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Worker> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Worker {
                    id: row.get(0),
                    key: row.get(0),
                    imie: row.get(1),
                    nazwisko: row.get(2),
                    adres: row.get(3),
                    numer_telefon: row.get(4),
                    jezyki: serde_json::from_str::<Vec<JezykBasic>>(row.get(5))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Worker>>(),
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

pub fn update_certain_worker_json<'a>(
    params: RequestBody<WorkerBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
            .execute("UPDATE pracownik SET imie=$2, nazwisko=$3, adres=$4, numer_telefon=$5 where id=$1", &[&params.params.id,&params.params.imie,&params.params.nazwisko,&params.params.adres,&params.params.numer_telefon])
            .unwrap()
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

pub fn insert_certain_worker_json<'a>(
    params: RequestBody<WorkerInsert>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<i64>;
        let result: Response<i64>;

        let mut query_result: Vec<PilotDeleteQuery> = match connection.query(
            "INSERT INTO pracownik ( imie, nazwisko, adres, numer_telefon) values ($1,$2,$3,$4) returning id",
                &[
                    &params.params.imie,
                    &params.params.nazwisko,
                    &params.params.adres,
                    &params.params.numer_telefon,
                ],

        ) {
            Ok(result) => result
                .iter()
                .map(|row| PilotDeleteQuery { id: row.get(0) })
                .collect::<Vec<PilotDeleteQuery>>(),
            Err(result) => Vec::new(),
        };

        if query_result
            .get(0)
            .unwrap_or(&PilotDeleteQuery { id: 0 })
            .id
            > 0
        {
            result = Response {
                status: 200,
                message: "OK".to_owned(),
                result: query_result
                    .get(0)
                    .unwrap_or(&PilotDeleteQuery { id: 0 })
                    .id,
            };
        } else {
            result = Response {
                status: 500,
                message: "Cannot add new worker".to_owned(),
                result: 0,
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

pub fn add_language_to_worker_json<'a>(
    params: RequestBody<WorkerLanguageQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        if connection
            .query(
                "select * from jezyk where kod=$1",
                &[&params.params.language_kod],
            )
            .unwrap()
            .len()
            != 1
        {
            return HashMap::from([
                ("Status", "500 Internal Server Error".to_owned()),
                (
                    "Content",
                    "{result:'Kod języka nie jest jednoznaczny'}".to_owned(),
                ),
                ("Content-Type", "application/json".to_owned()),
            ]);
        }
        if connection
            .query(
                "select * from Pracownik where id=$1",
                &[&params.params.pracownik_id],
            )
            .unwrap()
            .len()
            != 1
        {
            return HashMap::from([
                ("Status", "500 Internal Server Error".to_owned()),
                (
                    "Content",
                    "{result:'Id pracownika nie jest jednoznaczne'}".to_owned(),
                ),
                ("Content-Type", "application/json".to_owned()),
            ]);
        }
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "insert into jezyk_pracownik (jezyk_kod, pracownik_id) values ($1,$2)",
                &[&params.params.language_kod, &params.params.pracownik_id],
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
                message: "Wystapil blad podczas dodwania powiazania".to_owned(),
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

pub fn remove_language_from_worker_json<'a>(
    params: RequestBody<WorkerLanguageQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "DELETE from jezyk_pracownik where pracownik_id=$1 and jezyk_kod=$2",
                &[&params.params.pracownik_id, &params.params.language_kod],
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
                message: "Wystapil blad podczas usuwania powiazania".to_owned(),
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

pub fn delete_certain_worker_json<'a>(
    params: RequestBody<WorkerDeleteQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;

        connection
            .execute(
                "Delete from jezyk_pracownik where pracownik_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        connection
            .execute(
                "Delete from pracownik_podroz where pracownik_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);

        let query_result = connection
            .execute("Delete from pracownik where id=$1", &[&params.params.id])
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Pracowik deleted".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Pracownik does not exist".to_owned(),
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
