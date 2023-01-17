use crate::{
    transport::TransportBasic,
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct FirmaTransportowa {
    pub id: i64,
    pub nazwa: String,
    pub adres: String,
    pub telefon: String,
    pub transporty: Vec<TransportBasic>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct FirmaTransportowaBasic {
    pub id: i64,
    pub nazwa: String,
    pub adres: String,
    pub telefon: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct FirmaTransportowaInsert {
    pub nazwa: String,
    pub adres: String,
    pub telefon: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct FirmaTransportowaDelete {
    pub id: i64,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct FirmaTransportowaQuery {
    pub id_list: Vec<i64>,
}
pub fn get_all_transport_company_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<FirmaTransportowa> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(
                    "select ft.id, ft.nazwa, ft.adres, ft.telefon,json_agg(t) 
                    from firma_transportowa ft 
                    left join transport_firma_transportowa fft on ft.id = fft.firma_transportowa_id
                    left join transport t on t.id = fft.transport_id
                    group by ft.id, ft.nazwa, ft.adres, ft.telefon",
                    &[],
                )
                .unwrap()
                .iter()
                .map(|row| FirmaTransportowa {
                    id: row.get(0),
                    nazwa: row.get(1),
                    adres: row.get(2),
                    telefon: row.get(3),
                    transporty: serde_json::from_str::<Vec<TransportBasic>>(row.get(4))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<FirmaTransportowa>>(),
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

pub fn get_certain_transport_company_json<'a>(
    params: RequestBody<FirmaTransportowaQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    let params_query: Vec<String> = params
        .params
        .id_list
        .iter()
        .map(|v| v.to_string())
        .collect();
    let mut query: String = "select ft.id, ft.nazwa, ft.adres, ft.telefon,json_agg(t) 
                             from firma_transportowa ft 
                             left join transport_firma_transportowa fft on ft.id = fft.firma_transportowa_id
                             left join transport t on t.id = fft.transport_id where fr.id in (".to_owned();
    query.push_str(params_query.join(",").as_str());
    query.push_str(") group by ft.id, ft.nazwa, ft.adres, ft.telefon");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<FirmaTransportowa> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| FirmaTransportowa {
                    id: row.get(0),
                    nazwa: row.get(1),
                    adres: row.get(2),
                    telefon: row.get(3),
                    transporty: serde_json::from_str::<Vec<TransportBasic>>(row.get(4))
                        .unwrap_or(Vec::new()),
                })
                .collect::<Vec<FirmaTransportowa>>(),
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
pub fn update_certain_transport_company_json<'a>(
    params: RequestBody<FirmaTransportowaBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .execute(
                    "UPDATE firma_transportowa SET nazwa=$2, telefon=$3, adres=$4 where id=$1",
                    &[
                        &params.params.id,
                        &params.params.nazwa,
                        &params.params.telefon,
                        &params.params.adres,
                    ],
                )
                .unwrap(),
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
pub fn insert_certain_transport_company_json<'a>(
    params: RequestBody<FirmaTransportowaInsert>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        let query_result = connection
            .execute(
                "INSERT INTO firma_transportowa (nazwa, adres, telefon) values ($1,$2,$3)",
                &[
                    &params.params.nazwa,
                    &params.params.adres,
                    &params.params.telefon,
                ],
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
                message: "Nie mozna dodac nowej firmy transportowej".to_owned(),
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

pub fn delete_certain_transport_company_json<'a>(
    params: RequestBody<FirmaTransportowaDelete>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;
        connection
            .execute(
                "Delete from transport_firma_transportowa where firma_transportowa_id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        let query_result = connection
            .execute(
                "Delete from firma_transportowa where id=$1",
                &[&params.params.id],
            )
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Firma transportowa zostala usunieta".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Nie mozna usunac firmy transportowej".to_owned(),
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
