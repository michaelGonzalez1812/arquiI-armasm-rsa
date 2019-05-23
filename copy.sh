#!/bin/bash

IP=192.168.100.7

./compile.sh
scp ./bin/rsa mikepi@$IP:/home/mikepi/rsa/rsa
scp ./bin/rsa-ref mikepi@$IP:/home/mikepi/rsa/rsa-ref
scp ./modelo-ref/rsa.c mikepi@$IP:/home/mikepi/rsa/rsa-ref.c
scp ./src/rsa.s mikepi@$IP:/home/mikepi/rsa/rsa.s
