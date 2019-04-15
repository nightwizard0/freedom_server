#!/bin/bash

openssl genrsa -out homeserver.key 2048
openssl ecparam -genkey -name secp384r1 -out homeserver.key
openssl req -new -x509 -sha256 -key homeserver.key -out homeserver.crt -days 3650