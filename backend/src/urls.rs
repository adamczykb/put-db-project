use serde_json::map::Values;
use serde_json::Value;

use crate::client::{
    get_all_clients_json, get_certain_clients_json, insert_certain_client_json,
    update_certain_client_json, Klient, KlientQuery,
};

use crate::views::http_response;
use crate::worker::{
    add_language_to_worker_json, get_all_workers_json, get_certain_workers_json,
    update_certain_worker_json, WorkerBasic, WorkerLanguageQuery, WorkerQuery,
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
                            match serde_json::from_str::<RequestBody<Klient>>(
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
                            //match serde_json::from_str::<RequestBody<WorkerBasic>>(
                            //request.get("Content").unwrap_or(&"".to_owned()),
                            //) {
                            //Ok(params) => {
                            //response.extend(insert_certain_client_json(params));
                            //}
                            //Err(error) => {
                            //println!("{}", error);
                            //response.extend(server_error("WRONG QUERY".to_owned()));
                            //}
                            //};
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
                            match serde_json::from_str::<RequestBody<Klient>>(
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
                        "client" => {}
                        "worker" => {}
                        "worker_language" => {}
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
