use postgres::Client;
use std::net::TcpListener;
use std::{env, fs};
use travel_office_server::ThreadPool;
use utils::get_postgres_client;
mod accommodation;
mod attraction;
mod client;
mod journey;
mod language;
mod pilot;
mod urls;
mod utils;
mod views;
mod worker;
fn main() {
    let client: Result<Client, postgres::Error> = get_postgres_client();
    let listener: TcpListener;

    // Setting up database conenction
    if env::args().len() > 1 && env::args().collect::<Vec<String>>()[1] == "DEBUG" {
        listener = TcpListener::bind("0.0.0.0:8000").unwrap();
    } else {
        listener = TcpListener::bind("0.0.0.0:8080").unwrap();
    }

    if client.is_ok() {
        let mut connection = client.unwrap();
        let mut table_exists: bool = false;
        for row in connection.query("SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename  = 'klient')", &[]).unwrap(){
            table_exists=row.get(0);
        }
        if !table_exists {
            println!(
                "{}",
                connection
                    .batch_execute(
                        fs::read_to_string("structure.sql")
                            .unwrap_or("".to_owned())
                            .as_str(),
                    )
                    .unwrap_err()
            );
        }
        connection.close();
    } else {
        println!("ERROR: Cannot connet to database!");
        return;
    }

    let pool = ThreadPool::new(4);

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        pool.execute(|| {
            utils::handle_connection(stream);
        });
    }
}
