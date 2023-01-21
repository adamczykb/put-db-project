use crate::{
    language::Jezyk,
    pilot::{PilotBasic, PilotDeleteQuery},
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
#[derive(Serialize, Deserialize, Debug)]
pub struct Atrakcja {
    pub key: i64,
    pub id: i64,
    pub nazwa: String,
    pub adres: String,
    pub sezon: Vec<String>,
    pub opis: String,
    pub koszt: i64,
    pub przewodnicy: Vec<PilotBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct AtrakcjaBasic {
    pub id: i64,
    pub nazwa: String,
    pub adres: String,
    pub sezon: Vec<String>,
    pub opis: String,
    pub koszt: i64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AtrakcjaInsert {
    pub nazwa: String,
    pub adres: String,
    pub sezon: Vec<String>,
    pub opis: String,
    pub koszt: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct AtrakcjaPilotQuery {
    pub przewodnik_id: i64,
    pub atrakcja_id: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct AtrakcjaQuery {
    pub id_list: Vec<i64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AtrakcjaDeleteQuery {
    pub id: i64,
}

pub fn get_all_attractions_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Atrakcja> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(
                    "select a.id, a.id,a.nazwa,a.adres,a.sezon,a.opis,a.koszt,json_agg(p)::text 
                        from atrakcja a
                        left join atrakcja_przewodnik ap on ap.atrakcja_id = a.id
                        left join przewodnik p on p.id = ap.przewodnik_id
                        group by a.id,a.nazwa,a.adres,a.sezon,a.opis,a.koszt",
                    &[],
                )
                .unwrap()
                .iter()
                .map(|row| Atrakcja {
                    key: row.get(0),
                    id: row.get(1),
                    nazwa: row.get(2),
                    adres: row.get(3),
                    sezon: row.get(4),
                    opis: row.get(5),
                    koszt: row.get(6),
                    przewodnicy: serde_json::from_str::<Vec<PilotBasic>>(row.get(7))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Atrakcja>>(),
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

pub fn get_certain_attraction_json<'a>(
    params: RequestBody<AtrakcjaQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .id_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query: String = "select a.id, a.id,a.nazwa,a.adres,a.sezon,a.opis,a.koszt,json_agg(p) 
                        from atrakcja a
                        left join atrakcja_przewodnik ap on ap.atrakcja_id = a.id
                        left join przewodnik p on p.id = ap.przewodnik_id
                        where a.id in ("
        .to_owned();
    query.push_str(params_query.join(",").as_str());
    query.push_str(") group by a.id,a.nazwa,a.adres,a.sezon,a.opis,a.koszt");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Atrakcja> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Atrakcja {
                    key: row.get(0),
                    id: row.get(1),
                    nazwa: row.get(2),
                    adres: row.get(3),
                    sezon: row.get(4),
                    opis: row.get(5),
                    koszt: row.get(6),
                    przewodnicy: serde_json::from_str::<Vec<PilotBasic>>(row.get(7))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Atrakcja>>(),
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

pub fn update_certain_attraction_json<'a>(
    params: RequestBody<AtrakcjaBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
            .execute("UPDATE atrakcja SET nazwa=$2, adres=$3, sezon=$4, opis=$5, koszt=$6 where id=$1", &[&params.params.id,&params.params.nazwa,&params.params.adres,&params.params.sezon,&params.params.opis,&params.params.koszt])
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

pub fn insert_certain_attraction_json<'a>(
    params: RequestBody<AtrakcjaInsert>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<i64>;

        let mut query_result: Vec<PilotDeleteQuery> = match connection.query(
            "INSERT INTO pracownik ( nazwa, adres, sezon, opis,koszt) values ($1,$2,$3,$4,$5)",
            &[
                &params.params.nazwa,
                &params.params.adres,
                &params.params.sezon,
                &params.params.opis,
                &params.params.koszt,
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
                message: "Cannot add new accommodation".to_owned(),
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

pub fn delete_certain_attraction_json<'a>(
    params: RequestBody<AtrakcjaDeleteQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;

        connection
            .execute(
                "Delete from atrakcja_przewodnik where atrakcja_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        connection
            .execute(
                "Delete from podroz_atrakcja where atrakcja_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);

        let query_result = connection
            .execute("Delete from atrakcja where id=$1", &[&params.params.id])
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Atrakcja usunieta".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Atrakcja does not exist".to_owned(),
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
