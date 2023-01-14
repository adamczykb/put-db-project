use std::collections::HashMap;

use crate::views::http_response;
use std::fs;
pub fn urls(request: HashMap<String, String>) -> String {
    let mut response: HashMap<&str, String> = HashMap::new();
    if request.get("Method").unwrap() == "GET" {
        let mut url = request.get("URL").unwrap().as_str();
        if url == "/api/" {
            response.extend(HashMap::from([
                ("Status", "200 OK".to_owned()),
                ("Content", "W".to_owned()),
            ]));
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
    } else {
        response.extend(HashMap::from([
            ("Status", "404 NOT FOUND".to_owned()),
            ("Content", "W".to_owned()),
        ]))
    };
    println!(" {}", response.get("Status").unwrap());
    http_response(response)
}
