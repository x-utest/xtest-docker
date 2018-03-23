#!/bin/bash

service nginx restart

mongod -f mongodb.conf

cd /xtest-server && python start.py
