use crate::urls::urls;
use chrono;
use postgres::{Client, NoTls};
use std::collections::HashMap;
use std::env;
use std::io::prelude::*;
use std::io::BufReader;
use std::net::TcpStream;
use std::str;

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
        buffer.get("Method").unwrap_or(&"".to_string()),
        buffer.get("URL").unwrap_or(&"".to_string()),
        buffer.get("Host").unwrap_or(&"".to_string())
    );
}

fn parse_request(stream: &TcpStream) -> HashMap<String, String> {
    let mut request: HashMap<String, String> = HashMap::new();
    let mut buff = BufReader::new(stream);
    let mut dictionary: String = String::new();
    loop {
        let mut buffer = vec![0u8; 1024];
        let result = buff.read(&mut buffer);

        match result {
            Ok(read) => {
                let buf_last = buffer.contains(&0u8);
                let text = String::from_utf8(buffer).unwrap();
                dictionary.extend(text.trim().chars());
                if buf_last {
                    break;
                }
            }
            Err(e) => println!("Error: {}", e),
        }
    }
    for line in dictionary.replace("\r", "").split("\n") {
        if !line.trim().is_empty() {
            if line.contains("HTTP") {
                let main_conection_data: Vec<&str> = line.split(" ").collect();
                request.insert(
                    "Method".to_string(),
                    main_conection_data
                        .get(0)
                        .unwrap_or(&"")
                        .trim_matches(char::from(0))
                        .to_string(),
                );
                request.insert(
                    "URL".to_string(),
                    main_conection_data
                        .get(1)
                        .unwrap_or(&"")
                        .trim_matches(char::from(0))
                        .to_string(),
                );
                request.insert(
                    "HTTP_version".to_string(),
                    main_conection_data
                        .get(2)
                        .unwrap_or(&"")
                        .trim_matches(char::from(0))
                        .to_string(),
                );
            } else {
                if line.contains(": ") && !line.contains("{") {
                    let splited_line: Vec<&str> =
                        line.trim_matches(char::from(0)).split(": ").collect();
                    request.insert(
                        splited_line.get(0).unwrap().to_string(),
                        splited_line.get(1).unwrap().to_string(),
                    );
                } else {
                    let content: String = line.trim_matches(char::from(0)).to_owned();
                    request.insert("Content".to_string(), content);
                    println!(
                        "{:?}",
                        line.trim_matches(char::from(0)).to_string().trim_start()
                    );
                    break;
                }
            }
        }
    }
    return request;
}

pub fn get_postgres_client() -> Result<Client, postgres::Error> {
    if env::args().len() > 1 && env::args().collect::<Vec<String>>()[1] == "DEBUG" {
        return Client::connect(
            "postgresql://postgres:alamakota@127.0.0.1:5432/postgres",
            NoTls,
        );
    } else {
        return Client::connect("postgresql://postgres:alamakota@db:5432/postgres", NoTls);
    }
}
