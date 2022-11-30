use std::collections::HashMap;

use crate::views::http_response;

pub fn urls(request: HashMap<String, String>) -> String {
    let mut response: HashMap<&str, &str> = HashMap::new();
    if request.get("Method").unwrap() == "GET" {
        match request.get("URL").unwrap().as_str() {
            "/" => response.extend(HashMap::from([("Status", "200 OK"), ("Content", "W")])),
            _ => response.extend(HashMap::from([
                ("Status", "404 NOT FOUND"),
                ("Content", ""),
            ])),
        }
    } else {
        response.extend(HashMap::from([
            ("Status", "404 NOT FOUND"),
            ("Content", "W"),
        ]))
    };
    println!(" {}", response.get("Status").unwrap());
    http_response(response)
}
