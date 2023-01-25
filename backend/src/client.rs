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
    pub key: String,
    pub pesel: String,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
    pub data_urodzenia: String,
    pub podroze: Vec<PodrozBasic>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct KlientBasic {
    pub pesel: String,
    pub imie: String,
    pub nazwisko: String,
    pub adres: String,
    pub numer_telefonu: String,
    pub data_urodzenia: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct KlientQuery {
    pub pesel_list: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct KlientDeleteQuery {
    pub pesel: String,
}

pub fn get_all_clients_json<'a>() -> HashMap<&'a str, String> {
    let client = get_postgres_client();
    if client.is_ok() {
        let mut connection = client.unwrap();
        let  result: ResponseArray<Klient> = ResponseArray{
            status: 200,
            message: "OK".to_owned(),
            result: connection.query(
                    "select z.pesel, z.pesel,z.imie,z.nazwisko, z.adres,z.numer_telefonu,cast(z.data_urodzenia as varchar), json_agg(p)::text from klient z left join klient_podroz zp on zp.klient_pesel=z.pesel left join podroz p on p.id=zp.podroz_id group by z.pesel,z.imie,z.nazwisko,z.adres,z.numer_telefonu,z.data_urodzenia  order by z.nazwisko", &[]
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
    let mut query: String = "".to_owned();
    query.push_str("select z.pesel, z.pesel,z.imie,z.nazwisko, z.adres,z.numer_telefonu,cast(z.data_urodzenia as varchar), json_agg(p)::text from klient z left join klient_podroz zp on zp.klient_pesel=z.pesel left join podroz p on p.id=zp.podroz_id where z.pesel in (");
    let mut query_parmas: Vec<String> = Vec::new();
    for i in params.params.pesel_list {
        let mut temp: String = String::from("\'");
        temp.push_str(i.as_str());
        temp.push_str("\'");
        query_parmas.push(temp);
    }
    query.push_str(query_parmas.join(",").as_str());
    query.push_str(") group by z.pesel,z.imie,z.nazwisko,z.adres,z.numer_telefonu,z.data_urodzenia order by z.nazwisko");
    println!("{}", query);
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
                .execute("UPDATE KLIENT SET imie=$2, nazwisko=$3, adres=$4, numer_telefonu=$5, data_urodzenia=TO_DATE($6,'YYYY-MM-DD') where pesel=$1", &[&params.params.pesel,&params.params.imie,&params.params.nazwisko,&params.params.adres,&params.params.numer_telefonu,&params.params.data_urodzenia])
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
        let result: Response<String>;

        let mut query_result: Vec<KlientDeleteQuery> = match connection.query(
            "INSERT INTO KLIENT (pesel, imie, nazwisko, adres, numer_telefonu, data_urodzenia) values ($1,$2,$3,$4,$5,TO_DATE($6,'DD-MM-YYYY')) returning pesel;", &[&params.params.pesel,&params.params.imie,&params.params.nazwisko,&params.params.adres,&params.params.numer_telefonu,&params.params.data_urodzenia]
        ) {
            Ok(result) => result
                .iter()
                .map(|row| KlientDeleteQuery { pesel: row.get(0) })
                .collect::<Vec<KlientDeleteQuery>>(),
            Err(result) => Vec::new(),
        };

        if query_result
            .get(0)
            .unwrap_or(&KlientDeleteQuery {
                pesel: "0".to_owned(),
            })
            .pesel
            != "0"
        {
            result = Response {
                status: 200,
                message: "OK".to_owned(),
                result: query_result
                    .get(0)
                    .unwrap_or(&KlientDeleteQuery {
                        pesel: "0".to_owned(),
                    })
                    .pesel
                    .to_string(),
            };
        } else {
            result = Response {
                status: 500,
                message: "Cannot add new klient".to_owned(),
                result: "0".to_owned(),
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
