FROM rust:latest

RUN apt-get update && apt-get install -y curl build-essential
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install -y nodejs
COPY . /opt/put-db-project


