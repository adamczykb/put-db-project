use serde_json::map::Values;
use serde_json::Value;

use crate::accommodation::{
    delete_certain_accommodation_json, get_all_accommodations_json, get_certain_accommodation_json,
    insert_certain_accommodation_json, update_certain_accommodation_json, ZakwaterowanieBasic,
    ZakwaterowanieDelete, ZakwaterowanieInsert, ZakwaterowanieQuery,
};
use crate::attraction::{
    delete_certain_attraction_json, get_all_attractions_json, get_certain_attraction_json,
    insert_certain_attraction_json, update_certain_attraction_json, AtrakcjaBasic,
    AtrakcjaDeleteQuery, AtrakcjaInsert, AtrakcjaPilotQuery, AtrakcjaQuery,
};
use crate::client::{
    delete_certain_client_json, get_all_clients_json, get_certain_clients_json,
    insert_certain_client_json, update_certain_client_json, Klient, KlientBasic, KlientDeleteQuery,
    KlientQuery,
};

use crate::etap::{
    delete_certain_etap_json, get_all_etap_json, get_certain_etap_json, insert_certain_etap_json,
    update_certain_etap_json, Etap, EtapBasic, EtapDelete, EtapInsert, EtapQuery,
};
use crate::journey::{
    add_accommodation_to_journey_json, add_attraction_to_journey_json, add_client_to_journey_json,
    add_etap_to_journey_json, add_pilot_to_journey_json, add_worker_to_journey_json,
    delete_certain_journey_json, get_all_journey_json, get_certain_journeys_json,
    insert_certain_journey_json, remove_accommodation_from_journey_json,
    remove_attraction_from_journey_json, remove_client_from_journey_json,
    remove_etap_from_journey_json, remove_pilot_from_journey_json, remove_worker_from_journey_json,
    update_certain_journey_json, PodrozAttractionQuery, PodrozBasic, PodrozDelete, PodrozEtapQuery,
    PodrozInsert, PodrozKlientQuery, PodrozPilotQuery, PodrozPracownikQuery, PodrozQuery,
    PodrozZakwaterowanieQuery,
};
use crate::language::{
    delete_certain_language_json, get_all_languages_json, get_certain_languages_json, JezykDelete,
    JezykQuery,
};
use crate::pilot::{
    add_attraction_to_pilot_json, add_language_to_pilot_json, delete_certain_pilot_json,
    get_all_pilots_json, get_certain_pilots_json, insert_certain_pilot_json,
    remove_attraction_from_pilot_json, remove_language_from_pilot_json, update_certain_pilot_json,
    PilotAttractionQuery, PilotBasic, PilotDeleteQuery, PilotInsert, PilotLanguageQuery,
    PilotQuery,
};
use crate::transport::{
    add_transport_company_to_transport_json, get_all_transport_json, get_certain_transport_json,
    remove_transport_company_from_transport_json, update_certain_transport_json, TransportBasic,
    TransportDelete, TransportFirmaTransportowaQuery, TransportInsert, TransportQuery,
};
use crate::transport_company::{
    delete_certain_transport_company_json, get_all_transport_company_json,
    get_certain_transport_company_json, insert_certain_transport_company_json,
    update_certain_transport_company_json, FirmaTransportowaBasic, FirmaTransportowaDelete,
    FirmaTransportowaInsert, FirmaTransportowaQuery,
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
    message_output.push_str("{\"result\":'");
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
                        "all_journey" => {
                            response.extend(get_all_journey_json());
                        }
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
                        "certain_journey" => {
                            match serde_json::from_str::<RequestBody<PodrozQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => response.extend(get_certain_journeys_json(params)),
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
                        "accommodation" => {
                            match serde_json::from_str::<RequestBody<ZakwaterowanieInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_accommodation_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "attraction" => {
                            match serde_json::from_str::<RequestBody<AtrakcjaInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_attraction_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "etap" => {
                            match serde_json::from_str::<RequestBody<EtapInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_etap_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "pilot" => {
                            match serde_json::from_str::<RequestBody<PilotInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("wrong query".to_owned()));
                                }
                            };
                        }
                        "journey" => {
                            match serde_json::from_str::<RequestBody<PodrozInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("wrong query".to_owned()));
                                }
                            };
                        }

                        "transport_company" => {
                            match serde_json::from_str::<RequestBody<FirmaTransportowaInsert>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(insert_certain_transport_company_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("wrong query".to_owned()));
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
                        "transport_company_transport" => {
                            match serde_json::from_str::<RequestBody<TransportFirmaTransportowaQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response
                                        .extend(add_transport_company_to_transport_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "pilot_attraction" => {
                            match serde_json::from_str::<RequestBody<PilotAttractionQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_attraction_to_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "pilot_language" => {
                            match serde_json::from_str::<RequestBody<PilotLanguageQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_language_to_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }

                        "journey_pilot" => {
                            match serde_json::from_str::<RequestBody<PodrozPilotQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_pilot_to_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_client" => {
                            match serde_json::from_str::<RequestBody<PodrozKlientQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_client_to_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_attraction" => {
                            match serde_json::from_str::<RequestBody<PodrozAttractionQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_attraction_to_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_worker" => {
                            match serde_json::from_str::<RequestBody<PodrozPracownikQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_worker_to_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_etap" => {
                            match serde_json::from_str::<RequestBody<PodrozEtapQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_etap_to_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_accommodation" => {
                            match serde_json::from_str::<RequestBody<PodrozZakwaterowanieQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(add_accommodation_to_journey_json(params));
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
                        "certain_accommodation" => {
                            match serde_json::from_str::<RequestBody<ZakwaterowanieBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_accommodation_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_attraction" => {
                            match serde_json::from_str::<RequestBody<AtrakcjaBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_attraction_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_etap" => {
                            match serde_json::from_str::<RequestBody<EtapBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_etap_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_pilot" => {
                            match serde_json::from_str::<RequestBody<PilotBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_transport" => {
                            match serde_json::from_str::<RequestBody<TransportBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_transport_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_transport_company" => {
                            match serde_json::from_str::<RequestBody<FirmaTransportowaBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_transport_company_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "certain_journey" => {
                            match serde_json::from_str::<RequestBody<PodrozBasic>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(update_certain_journey_json(params));
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
                        "accommodation" => {
                            match serde_json::from_str::<RequestBody<ZakwaterowanieDelete>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_accommodation_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "attraction" => {
                            match serde_json::from_str::<RequestBody<AtrakcjaDeleteQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_attraction_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "etap" => {
                            match serde_json::from_str::<RequestBody<EtapDelete>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_etap_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "language" => {
                            match serde_json::from_str::<RequestBody<JezykDelete>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_language_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "pilot" => {
                            match serde_json::from_str::<RequestBody<PilotDeleteQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "transport_company" => {
                            match serde_json::from_str::<RequestBody<FirmaTransportowaDelete>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_transport_company_json(params));
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
                        "pilot_language" => {
                            match serde_json::from_str::<RequestBody<PilotLanguageQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_language_from_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "pilot_attraction" => {
                            match serde_json::from_str::<RequestBody<PilotAttractionQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_attraction_from_pilot_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "transport_transport_company" => {
                            match serde_json::from_str::<RequestBody<TransportFirmaTransportowaQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_transport_company_from_transport_json(
                                        params,
                                    ));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey" => {
                            match serde_json::from_str::<RequestBody<PodrozDelete>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(delete_certain_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }

                        "journey_pilot" => {
                            match serde_json::from_str::<RequestBody<PodrozPilotQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_pilot_from_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_client" => {
                            match serde_json::from_str::<RequestBody<PodrozKlientQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_client_from_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_attraction" => {
                            match serde_json::from_str::<RequestBody<PodrozAttractionQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_attraction_from_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_worker" => {
                            match serde_json::from_str::<RequestBody<PodrozPracownikQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_worker_from_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_etap" => {
                            match serde_json::from_str::<RequestBody<PodrozEtapQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_etap_from_journey_json(params));
                                }
                                Err(error) => {
                                    println!("{}", error);
                                    response.extend(server_error("WRONG QUERY".to_owned()));
                                }
                            };
                        }
                        "journey_accommodation" => {
                            match serde_json::from_str::<RequestBody<PodrozZakwaterowanieQuery>>(
                                request.get("Content").unwrap_or(&"".to_owned()),
                            ) {
                                Ok(params) => {
                                    response.extend(remove_accommodation_from_journey_json(params));
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
