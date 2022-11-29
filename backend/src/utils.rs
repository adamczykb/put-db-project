use chrono;
use std::collections::HashMap;
use std::io::prelude::*;
use std::io::BufReader;
use std::net::TcpStream;

use crate::urls::urls;

pub fn handle_connection(mut stream: TcpStream) {
    let request: HashMap<String, String> = parse_request(&stream);
    log_server_incoming_connections(&request);

    stream.write(urls(request).as_bytes()).unwrap();
    stream.flush().unwrap();
}

fn log_server_incoming_connections(buffer: &HashMap<String, String>) {
    print!(
        "{} | {} {} {}",
        chrono::prelude::Local::now().format("%H:%M:%S %d.%m.%Y"),
        buffer.get("Method").unwrap(),
        buffer.get("URL").unwrap(),
        buffer.get("Host").unwrap()
    );
}

fn parse_request(stream: &TcpStream) -> HashMap<String, String> {
    let mut request: HashMap<String, String> = HashMap::new();

    for v in BufReader::new(stream).lines() {
        let temp = v.unwrap();
        if !temp.is_empty() {
            if temp.contains("HTTP") {
                let main_conection_data: Vec<&str> = temp.split(" ").collect();
                request.insert(
                    "Method".to_string(),
                    main_conection_data.get(0).unwrap().to_string(),
                );
                request.insert(
                    "URL".to_string(),
                    main_conection_data.get(1).unwrap().to_string(),
                );
                request.insert(
                    "HTTP_version".to_string(),
                    main_conection_data.get(2).unwrap().to_string(),
                );
            } else {
                let splited_line: Vec<&str> = temp.split(": ").collect();
                request.insert(
                    splited_line.get(0).unwrap().to_string(),
                    splited_line.get(1).unwrap().to_string(),
                );
            }
        } else {
            break;
        }
    }
    request
}
