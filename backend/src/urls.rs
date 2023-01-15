use serde_json::map::Values;
use serde_json::Value;

use crate::views::get_all_clients_json;
use crate::views::get_certain_clients_json;
use crate::views::http_response;
use crate::views::KlientQuery;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;

#[derive(Serialize, Deserialize, Debug)]
pub struct RequestBody<T> {
    pub params: T,
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
                        _ => response.extend(HashMap::from([
                            ("Status", "404 NOT FOUND".to_owned()),
                            ("Content", "".to_owned()),
                        ])),
                    },
                    _ => {
                        response.extend(HashMap::from([
                            ("Status", "404 NOT FOUND".to_owned()),
                            ("Content", "".to_owned()),
                        ]));
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
                    response.extend(HashMap::from([
                        ("Status", "404 NOT FOUND".to_owned()),
                        ("Content", "".to_owned()),
                    ]))
                }
            }
        }
        "POST" => {
            let mut url = request.get("URL").unwrap().as_str();
            if url.split('/').collect::<Vec<&str>>()[1] == "api" {
                match url.split('/').collect::<Vec<&str>>()[2] {
                    "get" => match url.split('/').collect::<Vec<&str>>()[3] {
                        "certain_clients" => {
                            let params: RequestBody<KlientQuery> =
                                match serde_json::from_str::<RequestBody<KlientQuery>>(
                                    request.get("Content").unwrap_or(&"".to_owned()),
                                ) {
                                    Ok(params) => params,
                                    Err(error) => {
                                        println!("{}", error);
                                        response.extend(HashMap::from([
                                            ("Status", "500 WRONG QUERY".to_owned()),
                                            ("Content", "{result:'WRONG QUERY'}".to_owned()),
                                            ("Content-Type", "application/json".to_owned()),
                                        ]));
                                        return String::from("");
                                    }
                                };
                            response.extend(get_certain_clients_json(params));
                        }
                        _ => response.extend(HashMap::from([
                            ("Status", "404 NOT FOUND".to_owned()),
                            ("Content", "".to_owned()),
                        ])),
                    },
                    //"push" => {};
                    //"update" => {};
                    _ => {
                        response.extend(HashMap::from([
                            ("Status", "404 NOT FOUND".to_owned()),
                            ("Content", "".to_owned()),
                        ]));
                    }
                }
            }
        }
        _ => {
            response.extend(HashMap::from([
                ("Status", "404 NOT FOUND".to_owned()),
                ("Content", "".to_owned()),
            ]));
        }
    };
    println!(" {}", response.get("Status").unwrap());
    http_response(response)
}
