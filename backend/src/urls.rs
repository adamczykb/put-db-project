use serde_json::map::Values;
use serde_json::Value;

use crate::accommodation::{
    get_all_accommodations_json, get_certain_accommodation_json, ZakwaterowanieQuery,
};
use crate::attraction::{get_all_attractions_json, get_certain_attraction_json, AtrakcjaQuery};
use crate::client::{
    delete_certain_client_json, get_all_clients_json, get_certain_clients_json,
    insert_certain_client_json, update_certain_client_json, Klient, KlientBasic, KlientDeleteQuery,
    KlientQuery,
};

use crate::etap::{get_all_etap_json, get_certain_etap_json, EtapQuery};
use crate::language::{get_all_languages_json, get_certain_languages_json, JezykQuery};
use crate::pilot::{get_all_pilots_json, get_certain_pilots_json, PilotQuery};
use crate::transport::{get_all_transport_json, get_certain_transport_json, TransportQuery};
use crate::transport_company::{
    get_all_transport_company_json, get_certain_transport_company_json, FirmaTransportowaQuery,
};
use crate::views::http_response;
use crate::worker::{
    add_language_to_worker_json, delete_certain_worker_json, get_all_workers_json,
    get_certain_workers_json, insert_certain_worker_json, remove_language_from_worker_json,
    update_certain_worker_json, WorkerBasic, WorkerDeleteQuery, WorkerInsert, WorkerLanguageQuery,
    WorkerQuery,
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;

#[derive(Serialize, Deserialize, Debug)]
pub struct RequestBody<T> {
    pub params: T,
}

fn not_found() -> HashMap<&'static str, String> {
    HashMap::from([
        ("Status", "404 NOT FOUND".to_owned()),
        ("Content", "".to_owned()),
    ])
}

fn server_error(message: String) -> HashMap<&'static str, String> {
    let mut message_output: String = String::new();
    message_output.push_str("{result:'");
    message_output.push_str(message.as_str());
    message_output.push_str("'}");
    HashMap::from([
        ("Status", "500 Internal Server Error".to_owned()),
        ("Content", message_output),
        ("Content-Type", "application/json".to_owned()),
    ])
}

pub fn urls(request: HashMap<String, String>) -> String {
    let mut response: HashMap<&str, String> = HashMap::new();
    match request.get("Method").unwrap_or(&"".to_owned()).as_str() {
        "GET" => {
            let mut url = request.get("URL").unwrap().as_str();
            if url.split('/').collect::<Vec<&str>>()[1] == "api" {
                match url.split('/').collect::<Vec<&str>>()[2] {
                    "get" => match url.split('/').collect::<Vec<&str>>()[3] {
                        "all_clients" => {
                            response.extend(get_all_clients_json());
                        }
                        "all_workers" => {
                            response.extend(get_all_workers_json());
                        }
                        "all_accommodations" => {
                            response.extend(get_all_accommodations_json());
                        }
                        "all_languages" => {
                            response.extend(get_all_languages_json());
                        }
                        "all_attractions" => {
                            response.extend(get_all_attractions_json());
                        }
                        "all_etaps" => {
                            response.extend(get_all_etap_json());
                        }
                        //"all_journeys" => {
                        //response.extend(get_all_journeys_json());
                        //}
                        "all_pilots" => {
                            response.extend(get_all_pilots_json());
                        }
                        "all_transport" => {
                            response.extend(get_all_transport_json());
                        }
                        "all_transport_company" => {
                            response.extend(get_all_transport_company_json());
                        }
                        _ => response.extend(not_found()),
                    },
                    _ => {
                        response.extend(not_found());
                    }
                }
            } else {
                if url.split('/').collect::<Vec<&str>>()[1] == "static" {
                    url = url.split("/").last().unwrap();
                } else {
                    url = "index.html"
                }
                let content = fs::read_to_string("./dist/".to_owned() + url);
                if content.is_ok() {
                    response.extend(HashMap::from([
                        ("Status", "200 OK".to_owned()),
                        ("Content", content.unwrap().to_owned()),
                    ]))
                } else {
                    response.extend(not_found())
                }
            }
        }
        "OPTIONS" => {
            response.extend(HashMap::from([
                ("Status", "204 No Content".to_owned()),
                ("Content", "".to_owned()),
            ]));
        }
        "POST" => {
            let url = request.get("URL").unwrap().as_str();
            if url.split('/').collect::<Vec<&str>>()[1] == "api" {
                match url.split('/').collect::<Vec<&str>>()[2] {
                    "get" => match url
                        .split('/')
                        .collect::<Vec<&str>>()
                        .get(3)
                        .unwrap_or(&"")
                        .to_owned()
                    {
                        "certain_clients" => {
                            match serde_json::from_str::<RequestBody<KlientQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_clients_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_workers" => {
                            match serde_json::from_str::<RequestBody<WorkerQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_workers_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_accommodations" => {
                            match serde_json::from_str::<RequestBody<ZakwaterowanieQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(get_certain_accommodation_json(params))
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_attractions" => {
                            match serde_json::from_str::<RequestBody<AtrakcjaQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_attraction_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_etaps" => {
                            match serde_json::from_str::<RequestBody<EtapQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_etap_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_languages" => {
                            match serde_json::from_str::<RequestBody<JezykQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_languages_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_pilots" => {
                            match serde_json::from_str::<RequestBody<PilotQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_pilots_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_transports" => {
                            match serde_json::from_str::<RequestBody<TransportQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_transport_json(params)),
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_transport_companies" => {
                            match serde_json::from_str::<RequestBody<FirmaTransportowaQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(get_certain_transport_company_json(params))
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        _ => response.extend(not_found()),
                    },
                    "push" => match url
                        .split('/')
                        .collect::<Vec<&str>>()
                        .get(3)
                        .unwrap_or(&"")
                        .to_owned()
                    {
                        "client" => {
                            match serde_json::from_str::<RequestBody<KlientBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_client_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "worker" => {
                            match serde_json::from_str::<RequestBody<WorkerInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_worker_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "worker_language" => {
                            match serde_json::from_str::<RequestBody<WorkerLanguageQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_language_to_worker_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        _ => {
                            response.extend(not_found());
                        }
                    },
                    "update" => match url
                        .split('/')
                        .collect::<Vec<&str>>()
                        .get(3)
                        .unwrap_or(&"")
                        .to_owned()
                    {
                        "certain_client" => {
                            match serde_json::from_str::<RequestBody<KlientBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_client_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_worker" => {
                            match serde_json::from_str::<RequestBody<WorkerBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_worker_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        _ => {
                            response.extend(not_found());
                        }
                    },
                    "delete" => match url
                        .split('/')
                        .collect::<Vec<&str>>()
                        .get(3)
                        .unwrap_or(&"")
                        .to_owned()
                    {
                        "client" => {
                            match serde_json::from_str::<RequestBody<KlientDeleteQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_client_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "worker" => {
                            match serde_json::from_str::<RequestBody<WorkerDeleteQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_worker_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "worker_language" => {
                            match serde_json::from_str::<RequestBody<WorkerLanguageQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_language_from_worker_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        _ => {
                            response.extend(not_found());
                        }
                    },
                    _ => {
                        response.extend(not_found());
                    }
                }
            }
        }
        _ => {
            response.extend(not_found());
        }
    };
    println!(" {}", response.get("Status").unwrap());
    http_response(response)
}
