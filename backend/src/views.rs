use crate::{urls::RequestBody, utils::get_postgres_client};
use serde::{Deserialize, Serialize};
use serde_json::{map::Values, Value};
use std::collections::HashMap;

#[derive(Serialize, Deserialize, Debug)]
pub struct Jezyk {
    pub kod: String,
    pub nazwa: String,
}

#[derive(Serialize, Deserialize)]
pub struct ResponseArray<T> {
    pub status: i32,
    pub message: String,
    pub result: Vec<T>,
}
#[derive(Serialize, Deserialize)]
pub struct Response<T> {
    pub status: i32,
    pub message: String,
    pub result: T,
}

pub fn http_response(params: HashMap<&str, String>) -> String {
    if params.get("Content-Type").unwrap_or(&"".to_owned()) == "" {
        return format!(
            "HTTP/1.1 {}\r\nContent-Length: {}\r\nAccess-Control-Allow-Origin: *\r\nAccess-Control-Allow-Methods: POST, GET, OPTIONS\r\nAccess-Control-Allow-Headers: X-PINGOTHER, Content-Type\r\nAccess-Control-Max-Age: 86400\r\n\r\n{}",
            params.get("Status").unwrap(),
            params.get("Content").unwrap().len(),
            params.get("Content").unwrap()
        );
    } else {
        return format!(
            "HTTP/1.1 {}\r\nContent-Length: {}\r\nContent-Type:{}\r\nAccess-Control-Allow-Origin: *\r\nAccess-Control-Allow-Methods: POST, GET, OPTIONS\r\nAccess-Control-Allow-Headers: X-PINGOTHER, Content-Type\r\nAccess-Control-Max-Age: 86400\r\n{}",
            params.get("Status").unwrap(),
            params.get("Content").unwrap().len(),
            params.get("Content-Type").unwrap_or(&"".to_owned()),
            params.get("Content").unwrap()
        );
    }
}
