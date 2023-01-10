#!/bin/bash

cd /opt/put-db-project/frontend;
npm run build;
cd ./dist
rm *.map;


source /opt/put-db-project/backend/target/release/travel_office_server
