use std::collections::HashMap;

pub fn http_response(params: HashMap<&str, &str>) -> String {
    return format!(
        "HTTP/1.1 {}\r\nContent-Length: {}\r\n\r\n{}",
        params.get("Status").unwrap(),
        params.get("Content").unwrap().len(),
        params.get("Content").unwrap()
    );
}
