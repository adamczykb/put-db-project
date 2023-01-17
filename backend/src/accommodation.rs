use crate::{
    journey::{Podroz, PodrozBasic},
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Zakwaterowanie {
    pub id: i64,
    pub nazwa: String,
    pub koszt: i64,
    pub ilosc_miejsc: i64,
    pub standard_zakwaterowania: String,
    pub adres: String,
    pub podroze: Vec<PodrozBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct ZakwaterowanieBasic {
    pub id: i64,
    pub nazwa: String,
    pub koszt: i64,
    pub ilosc_miejsc: i64,
    pub standard_zakwaterowania: String,
    pub adres: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct ZakwaterowanieInsert {
    pub nazwa: String,
    pub koszt: i64,
    pub ilosc_miejsc: i64,
    pub standard_zakwaterowania: String,
    pub adres: String,
    pub podroze: Vec<PodrozBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct ZakwaterowanieDelete {
    pub id: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct ZakwaterowanieQuery {
    pub id_list: Vec<i64>,
}
pub fn get_all_accommodations_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Zakwaterowanie> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query("select z.id,z.nazwa,z.koszt ,z.ilosc_miejsc,z.standard_zakwaterowania,z.adres, json_agg(p)::text from zakwaterowanie z left join zakwaterowanie_podroz zp on zp.zakwaterowanie_id=z.id left join podroz p on p.id=zp.podroz_id group by z.id,z.nazwa,z.koszt,z.ilosc_miejsc,z.standard_zakwaterowania,z.adres", &[])
                .unwrap()
                .iter()
                .map(|row| Zakwaterowanie {
                    id:row.get(0),
                            nazwa: row.get(1),
                            koszt:row.get(2),
                            ilosc_miejsc: row.get(3),
                            standard_zakwaterowania: row.get(4),
                            adres: row.get(5),
                            podroze: serde_json::from_str::<Vec<PodrozBasic>>(row.get(6)  ).unwrap_or(Vec::new())
                })
                .collect::<Vec<Zakwaterowanie>>(),
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

pub fn get_certain_accommodation_json<'a>(
    params: RequestBody<ZakwaterowanieQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .id_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query: String = "select z.id,z.nazwa,z.koszt,z.ilosc_miejsc,z.standard_zakwaterowania,z.adres, json_agg(p)::text from zakwaterowanie z left join zakwaterowanie_podroz zp on zp.zakwaterowanie_id=z.id left join podroz p on p.id=zp.podroz_id where z.id in (".to_owned();
    query.push_str(params_query.join(",").as_str());
    query.push_str(
        ") group by z.id,z.nazwa,z.koszt,z.ilosc_miejsc,z.standard_zakwaterowania,z.adres",
    );
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Zakwaterowanie> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Zakwaterowanie {
                    id: row.get(0),
                    nazwa: row.get(1),
                    koszt: row.get(2),
                    ilosc_miejsc: row.get(3),
                    standard_zakwaterowania: row.get(4),
                    adres: row.get(5),
                    podroze: serde_json::from_str::<Vec<PodrozBasic>>(row.get(6))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Zakwaterowanie>>(),
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

pub fn insert_certain_accommodation_json<'a>(
    params: RequestBody<ZakwaterowanieInsert>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "INSERT INTO zakwaterowanie (nazwa,koszt,ilosc_miejsc,standard_zakwaterowania,adres) values ($1,$2,$3,$4,$5)",
                &[&params.params.nazwa, &params.params.koszt, &params.params.ilosc_miejsc, &params.params.standard_zakwaterowania, &params.params.adres],
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
                message: "Nie mozna dodac zakwaterowania".to_owned(),
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

pub fn update_certain_accommodation_json<'a>(
    params: RequestBody<ZakwaterowanieBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .execute("UPDATE zakwaterowanie SET nazwa=$1,koszt=$2,ilosc_miejsc=$3,standard_zakwaterowania=$4,adres=$5 where id=$1", &[&params.params.id,&params.params.nazwa,&params.params.koszt,&params.params.ilosc_miejsc,&params.params.standard_zakwaterowania,&params.params.adres])
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

pub fn delete_certain_accommodation_json<'a>(
    params: RequestBody<ZakwaterowanieDelete>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        connection
            .execute(
                "Delete from zakwaterowanie_podroz where zakwaterowanie_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);

        let query_result = connection
            .execute(
                "Delete from zakwaterowanie where kod=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Zakwaterowanie usuniete".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Nie mozna usunac zakwaterowania".to_owned(),
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
