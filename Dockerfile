FROM rust:latest

RUN apt-get update && apt-get install -y curl build-essential
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install -y nodejs
COPY . /opt/put-db-project
WORKDIR /opt/put-db-project/frontend
WORKDIR /opt/put-db-project/frontend/dist
#RUN rm *.map
WORKDIR /opt/put-db-project/backend
RUN cargo build --release
#CMD ["/opt/put-db-project/backend/target/release/travel_office_server"]

