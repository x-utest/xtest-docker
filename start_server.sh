#!/bin/bash

service nginx restart

cd /xtest-server && python start.py
