FROM rust:latest

COPY . /opt/backend
WORKDIR /opt/backend
RUN cargo build --release

CMD ["./target/release/travel_office_server"]
