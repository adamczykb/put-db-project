#!/bin/bash
cd /opt/put-db-project/backend
cargo build --release
cd /opt/put-db-project/frontend
echo "Frontend is set up"
npm install
npm run build || true
cd ./dist
rm *.map
cd ..
cp ./dist ../backend/ -r
echo "Server started"
cd /opt/put-db-project/backend
exec /opt/put-db-project/backend/target/release/travel_office_server
