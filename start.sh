#!/bin/bash

mongod -f mongodb.conf

cd /xtest-server && python start.py

