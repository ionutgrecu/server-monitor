#!/bin/bash

cd "$(dirname "$0")"
source .env

bash cpu.sh
bash disk.sh
