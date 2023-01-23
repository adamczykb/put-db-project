use crate::{
    journey::PodrozBasic,
    pilot::PilotDeleteQuery,
    urls::RequestBody,
    utils::get_postgres_client,
    views::{Response, ResponseArray},
};
use serde::{Deserialize, Serialize};
use serde_json::{map::Values, Value};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Klient {
    pub key: i64,
    pub pesel: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
    pub data_urodzenia: String,
    pub podroze: Vec<PodrozBasic>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct KlientBasic {
    pub pesel: i64,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
    pub data_urodzenia: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct KlientQuery {
    pub pesel_list: Vec<i64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct KlientDeleteQuery {
    pub pesel: i64,
}

pub fn get_all_clients_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let  result: ResponseArray<Klient> = ResponseArray{
            status: 200,
            message: "OK".to_owned(),
            result: connection.query(
                    "select z.pesel, z.pesel,z.imie,z.nazwisko, z.adres,z.numer_telefonu,cast(z.data_urodzenia as varchar), json_agg(p)::text from klient z left join klient_podroz zp on zp.klient_pesel=z.pesel left join podroz p on p.id=zp.podroz_id group by z.pesel,z.imie,z.nazwisko,z.adres,z.numer_telefonu,z.data_urodzenia", &[]
                    ).unwrap().iter().map(|row| {
                        Klient{
                    key: row.get(0),
                            pesel:row.get(1),
                            imie: row.get(2),
                            nazwisko: row.get(3),
                            adres: row.get(4),
                            numer_telefonu: row.get(5),
                            data_urodzenia: row.get(6),
                            podroze: serde_json::from_str::<Vec<PodrozBasic>>(row.get(7)  ).unwrap_or(Vec::new())
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
    let mut query:String = "select z.pesel, z.pesel,z.imie,z.nazwisko, z.adres,z.numer_telefonu,cast(z.data_urodzenia as varchar), json_agg(p)::text from klient z left join klient_podroz zp on zp.klient_pesel=z.pesel left join podroz p on p.id=zp.podroz_id where pesel in (".to_owned() ;
    query.push_str(params_query.join(",").as_str());
    query
        .push_str(") group by z.pesel,z.imie,z.nazwisko,z.adres,z.numer_telefonu,z.data_urodzenia");
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: ResponseArray<Klient> = ResponseArray {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .query(&query, &[])
                .unwrap()
                .iter()
                .map(|row| Klient {
                    key: row.get(0),
                    pesel: row.get(1),
                    imie: row.get(2),
                    nazwisko: row.get(3),
                    adres: row.get(4),
                    numer_telefonu: row.get(5),
                    data_urodzenia: row.get(6),
                    podroze: serde_json::from_str::<Vec<PodrozBasic>>(row.get(7))
                        .unwrap_or(Vec::new()),
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

pub fn update_certain_client_json<'a>(
    params: RequestBody<KlientBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64> = Response {
            status: 200,
            message: "OK".to_owned(),
            result: connection
                .execute("UPDATE KLIENT SET imie=$2, nazwisko=$3, adres=$4, numer_telefonu=$5, data_urodzenia=TO_DATE($6,'DD-MM-YYYY') where pesel=$1", &[&params.params.pesel,&params.params.imie,&params.params.nazwisko,&params.params.adres,&params.params.numer_telefonu,&params.params.data_urodzenia])
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

pub fn insert_certain_client_json<'a>(
    params: RequestBody<KlientBasic>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<i64>;

        let mut query_result: Vec<PilotDeleteQuery> = match connection.query(
            "INSERT INTO KLIENT (pesel, imie, nazwisko, adres, numer_telefonu, data_urodzenia) values ($1,$2,$3,$4,$5,TO_DATE($6,'DD-MM-YYYY'))", &[&params.params.pesel,&params.params.imie,&params.params.nazwisko,&params.params.adres,&params.params.numer_telefonu,&params.params.data_urodzenia]
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
                message: "Cannot add new klient".to_owned(),
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

pub fn delete_certain_client_json<'a>(
    params: RequestBody<KlientDeleteQuery>,
) -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let result: Response<u64>;

        connection
            .execute(
                "Delete from klient_podroz where klient_pesel=$1",
                &[&params.params.pesel],
            )
            .unwrap_or(0);

        let query_result = connection
            .execute("Delete from klient where pesel=$1", &[&params.params.pesel])
            .unwrap_or(0);
        if query_result > 0 {
            result = Response {
                status: 200,
                message: "Klient deleted".to_owned(),
                result: query_result,
            };
        } else {
            result = Response {
                status: 500,
                message: "Klient does not exist".to_owned(),
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
