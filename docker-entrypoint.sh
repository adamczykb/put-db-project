#!/bin/bash

cd /opt/put-db-project/frontend;
echo "Frontend is set up";
npm install
npm run build || true;
cd ./dist
rm *.map;
echo "Server started";
exec /opt/put-db-project/backend/target/release/travel_office_server
