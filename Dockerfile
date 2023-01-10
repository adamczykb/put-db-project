FROM rust:latest

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install -y nodejs
COPY . /opt/put-db-project
WORKDIR /opt/put-db-project/frontend
RUN npm install
RUN npm run build || true
WORKDIR /opt/put-db-project/frontend/dist
RUN rm *.map
WORKDIR /opt/put-db-project/backend
RUN cargo build --release
CMD ["./target/release/travel_office_server"]

