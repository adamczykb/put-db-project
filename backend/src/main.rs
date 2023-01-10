use std::net::TcpListener;

use travel_office_server::ThreadPool;
mod urls;
mod utils;
mod views;
//const FRONTEND_DIR: &str = "./src/frontend/build/";

fn main() {
    let listener = TcpListener::bind("0.0.0.0:8080").unwrap();
    let pool = ThreadPool::new(4);

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        pool.execute(|| {
            utils::handle_connection(stream);
        });
    }
}
