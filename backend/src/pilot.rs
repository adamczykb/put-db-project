use crate::{
    attraction::AtrakcjaBasic,
    journey::PodrozBasic,
    language::{Jezyk, JezykBasic},
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Pilot {
    pub key: i64,
    pub id: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
    pub jezyki: Vec<JezykBasic>,
    pub podroze: Vec<PodrozBasic>,
    pub atrakcje: Vec<AtrakcjaBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct PilotBasic {
    pub key: i64,
    pub id: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct PilotInsert {
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct PilotLanguageQuery {
    pub przewodnik_id: i64,
    pub language_kod: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct PilotAttractionQuery {
    pub przewodnik_id: i64,
    pub atrakcja_id: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct PilotQuery {
    pub id_list: Vec<i64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PilotDeleteQuery {
    pub id: i64,
}

pub fn get_all_pilots_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let  result: ResponseArray<Pilot> = ResponseArray{
            status: 200,
            message: "OK".to_owned(),
            result: connection.query(
                    "select  p.id,p.imie,p.nazwisko,p.adres,p.numer_telefonu, json_agg(po)::text, json_agg(je)::text, json_agg(a)::text  
                        from przewodnik p
                        left join przewodnik_podroz pp on pp.przewodnik_id=p.id 
                        left join podroz po on po.id=pp.podroz_id 
                        left join jezyk_przewodnik jp on jp.przewodnik_id=p.id 
                        left join jezyk je on je.kod=jp.jezyk_kod
                        left join atrakcja_przewodnik ap on ap.przewodnik_id=p.id 
                        left join atrakcja a on a.id=ap.atrakcja_id 
                        group by p.id,p.imie,p.nazwisko,p.adres,p.numer_telefonu", &[]
                    ).unwrap().iter().map(|row| {
                        Pilot{
                    key: row.get(0),
                            id:row.get(0),
                            imie: row.get(1),
                            nazwisko:row.get(2),
                            adres: row.get(3),
                            numer_telefonu: row.get(4),
                            podroze: serde_json::from_str::<Vec<PodrozBasic>>(row.get(5)  ).unwrap_or(Vec::new()),
                            jezyki: serde_json::from_str::<Vec<JezykBasic>>(row.get(6)  ).unwrap_or(Vec::new()),
                            atrakcje: serde_json::from_str::<Vec<AtrakcjaBasic>>(row.get(7)  ).unwrap_or(Vec::new())
                        }
            }).collect::<Vec<Pilot>>()
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

pub fn get_certain_pilots_json<'a>(params: RequestBody<PilotQuery>) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .id_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query:String = "select  p.id,p.imie,p.nazwisko,p.adres,p.numer_telefonu, json_agg(po)::text, json_agg(je)::text, json_agg(a)::text
                        from przewodnik p
                        left join przewodnik_podroz pp on pp.przewodnik_id=p.id 
                        left join podroz po on po.id=pp.podroz_id 
                        left join jezyk_przewodnik jp on jp.przewodnik_id=p.id 
                        left join jezyk je on je.kod=jp.jezyk_kod  
                        left join atrakcja_przewodnik ap on ap.przewodnik_id=p.id 
                        left join atrakcja a on a.id=ap.atrakcja_id
                        where p.id in (".to_owned() ;
    query.push_str(params_query.join(",").as_str());
    query.push_str(") group by p.id,p.imie,p.nazwisko,p.adres,p.numer_telefonu");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Pilot> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Pilot {
                    key: row.get(0),
                    id: row.get(0),
                    imie: row.get(1),
                    nazwisko: row.get(2),
                    adres: row.get(3),
                    numer_telefonu: row.get(4),
                    jezyki: serde_json::from_str::<Vec<JezykBasic>>(row.get(5)).unwrap_or(Vec::new()),
                    podroze: serde_json::from_str::<Vec<PodrozBasic>>(row.get(6))
                        .unwrap_or(Vec::new()),
                    atrakcje: serde_json::from_str::<Vec<AtrakcjaBasic>>(row.get(7))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Pilot>>(),
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

pub fn update_certain_pilot_json<'a>(params: RequestBody<PilotBasic>) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
            .execute("UPDATE przewodnik SET imie=$2, nazwisko=$3, adres=$4, numer_telefonu=$5 where id=$1", &[&params.params.id,&params.params.imie,&params.params.nazwisko,&params.params.adres,&params.params.numer_telefonu])
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

pub fn insert_certain_pilot_json<'a>(params: RequestBody<PilotInsert>) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<i64>;
        let mut query_result:Vec<PilotDeleteQuery>=
        match connection.query(
                "INSERT INTO przewodnik ( imie, nazwisko, adres, numer_telefonu) values ($1,$2,$3,$4) returning id",
                &[
                    &params.params.imie,
                    &params.params.nazwisko,
                    &params.params.adres,
                    &params.params.numer_telefonu,
                ],
            ){
            Ok(result)=>
                result
                .iter()
                .map(|row|
                    {
                        PilotDeleteQuery{ 
                            id:row.get(0)
                        }
                    })
                .collect::<Vec<PilotDeleteQuery>>(),
                Err(result)=> Vec::new()
        }; 

        if query_result.get(0).unwrap_or(&PilotDeleteQuery { id: 0 }).id > 0 {
            result = Response {
                status: 200,
                message: "OK".to_owned(),
                result: query_result.get(0).unwrap_or(&PilotDeleteQuery { id: 0 }).id,
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

pub fn add_language_to_pilot_json<'a>(
    params: RequestBody<PilotLanguageQuery>,
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
                "select * from przewodnik where id=$1",
                &[&params.params.przewodnik_id],
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
                "insert into jezyk_przewodnik (jezyk_kod, przewodnik_id) values ($1,$2)",
                &[&params.params.language_kod, &params.params.przewodnik_id],
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

pub fn remove_language_from_pilot_json<'a>(
    params: RequestBody<PilotLanguageQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "DELETE from jezyk_przewodnik where przewodnik_id=$1 and jezyk_kod=$2",
                &[&params.params.przewodnik_id, &params.params.language_kod],
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
pub fn add_attraction_to_pilot_json<'a>(
    params: RequestBody<PilotAttractionQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        if connection
            .query(
                "select * from atrakcja where id=$1",
                &[&params.params.atrakcja_id],
            )
            .unwrap()
            .len()
            != 1
        {
            return HashMap::from([
                ("Status", "500 Internal Server Error".to_owned()),
                (
                    "Content",
                    "{result:'Id atrakcji nie jest jednoznaczne'}".to_owned(),
                ),
                ("Content-Type", "application/json".to_owned()),
            ]);
        }
        if connection
            .query(
                "select * from przewodnik where id=$1",
                &[&params.params.przewodnik_id],
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
                "insert into atrakcja_przewodnik (atrakcja_id, przewodnik_id) values ($1,$2)",
                &[&params.params.atrakcja_id, &params.params.przewodnik_id],
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

pub fn remove_attraction_from_pilot_json<'a>(
    params: RequestBody<PilotAttractionQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "DELETE from atrakcja_przewodnik where przewodnik_id=$1 and atrakcja_id=$2",
                &[&params.params.przewodnik_id, &params.params.atrakcja_id],
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
pub fn delete_certain_pilot_json<'a>(
    params: RequestBody<PilotDeleteQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;

        connection
            .execute(
                "Delete from jezyk_przewodnik where przewodnik_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        connection
            .execute(
                "Delete from przewodnik_podroz where przewodnik_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        connection
            .execute(
                "Delete from atrakcja_przewodnik where przewodnik_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        let query_result = connection
            .execute("Delete from przewodnik where id=$1", &[&params.params.id])
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Przewodnik deleted".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Przewodnik does not exist".to_owned(),
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
