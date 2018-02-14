# !/bin/bash

today=$(date +%y%m%d_%H%M%S)

nohup sh bin/mmdtest.sh >> logs/${today}.log &
