use crate::{
    transport_company::FirmaTransportowaBasic,
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Transport {
    pub key: i64,
    pub id: i64,
    pub nazwa: String,
    pub liczba_jednostek: i64,
    pub liczba_miejsc: i64,
    pub firmy_transportowe: Vec<FirmaTransportowaBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct TransportBasic {
    pub id: i64,
    pub nazwa: String,
    pub liczba_jednostek: i64,
    pub liczba_miejsc: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct TransportInsert {
    pub nazwa: String,
    pub liczba_jednostek: i64,
    pub liczba_miejsc: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct TransportDelete {
    pub id: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct TransportQuery {
    pub id_list: Vec<i64>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct TransportFirmaTransportowaQuery {
    pub transport_id: i64,
    pub firma_transportowa_id: i64,
}
pub fn get_all_transport_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Transport> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(
                    "select t.id,t.nazwa, t.liczba_jednostek, t.liczba_miejsc, json_agg(ft)::text 
                    from transport t 
                    left join transport_firma_transportowa fft on t.id = fft.firma_transportowa_id
                    left join firma_transportowa ft on ft.id = fft.firma_transportowa_id
                    group by t.id, t.nazwa, t.liczba_jednostek, t.liczba_miejsc order by t.nazwa ",
                    &[],
                )
                .unwrap()
                .iter()
                .map(|row| Transport {
                    key: row.get(0),
                    id: row.get(0),
                    nazwa: row.get(1),
                    liczba_jednostek: row.get(2),
                    liczba_miejsc: row.get(3),
                    firmy_transportowe: serde_json::from_str::<Vec<FirmaTransportowaBasic>>(
                        row.get(4),
                    )
                    .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Transport>>(),
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

pub fn get_certain_transport_json<'a>(
    params: RequestBody<TransportQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .id_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query: String = "select  t.id, t.nazwa, t.liczba_jednostek, t.liczba_miejsc, json_agg(ft) 
                            from transport t 
                            left join transport_firma_transportowa fft on t.id = fft.firma_transportowa_id
                            left join firma_transportowa ft on ft.id = fft.firma_transportowa_id  t.id in (".to_owned();
    query.push_str(params_query.join(",").as_str());
    query
        .push_str(") group by t.id, t.nazwa, t.liczba_jednostek, t.liczba_miejsc order by t.nazwa");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Transport> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Transport {
                    key: row.get(0),
                    id: row.get(0),
                    nazwa: row.get(1),
                    liczba_jednostek: row.get(2),
                    liczba_miejsc: row.get(3),
                    firmy_transportowe: serde_json::from_str::<Vec<FirmaTransportowaBasic>>(
                        row.get(4),
                    )
                    .unwrap_or(Vec::new()),
                })
                .collect::<Vec<Transport>>(),
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
pub fn update_certain_transport_json<'a>(
    params: RequestBody<TransportBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
            .execute("UPDATE transport SET nazwa=$2, liczba_jednostek=$3, liczba_miejsc=$4 where id=$1", &[&params.params.id,&params.params.nazwa,&params.params.liczba_jednostek,&params.params.liczba_miejsc])
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

pub fn add_transport_company_to_transport_json<'a>(
    params: RequestBody<TransportFirmaTransportowaQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        if connection
            .query(
                "select * from firma_transportowa where id=$1",
                &[&params.params.firma_transportowa_id],
            )
            .unwrap()
            .len()
            != 1
        {
            return HashMap::from([
                ("Status", "500 Internal Server Error".to_owned()),
                (
                    "Content",
                    "{result:'Id firmy_transportowe nie jest jednoznaczne'}".to_owned(),
                ),
                ("Content-Type", "application/json".to_owned()),
            ]);
        }
        if connection
            .query(
                "select * from transport where id=$1",
                &[&params.params.transport_id],
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
                "insert into transport_firma_transportowa (transport_id, firma_transportowa_id) values ($1,$2)",
                &[&params.params.transport_id, &params.params.firma_transportowa_id],
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

pub fn remove_transport_company_from_transport_json<'a>(
    params: RequestBody<TransportFirmaTransportowaQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "DELETE from transport_firma_transportowa where transport_id=$1 and firma_transportowa_id=$2",
                &[&params.params.transport_id, &params.params.firma_transportowa_id],
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
//pub fn delete_certain_transport_json<'a>(
//params: RequestBody<TransportDelete>,
//) -> HashMap<&'a str, String> {
//let client = get_postgres_client();
//if client.is_ok() {
//let mut connection = client.unwrap();
//let result: Response<u64>;
//connection
//.execute(
//"Delete from transport_firma_transportowa where transport_id=$1",
//&[&params.params.id],
//)
//.unwrap_or(0);
//let query_result = connection
//.execute("Delete from transport where id=$1", &[&params.params.id])
//.unwrap_or(0);
//if query_result > 0 {
//result = Response {
//status: 200,
//message: "Transportowa zostal usuniety".to_owned(),
//result: query_result,
//};
//} else {
//result = Response {
//status: 500,
//message: "Nie mozna usunac transportu".to_owned(),
//result: query_result,
//};
//}
//let mut response = HashMap::from([
//(
//"Content",
//serde_json::to_string(&result).unwrap().to_owned(),
//),
//("Content-Type", "application/json".to_owned()),
//]);
//if result.status == 200 {
//response.extend([("Status", "200 OK".to_owned())]);
//} else {
//response.extend([("Status", "500 Internal Server Error".to_owned())]);
//}
//connection.close();
//return response;
//} else {
//println!("ERROR: Cannot connet to database!");
//return HashMap::from([
//("Status", "401 PERMISSION DENIED".to_owned()),
//("Content", "{result:'PERMISSION DENIED'}".to_owned()),
//("Content-Type", "application/json".to_owned()),
//]);
//}
//}
