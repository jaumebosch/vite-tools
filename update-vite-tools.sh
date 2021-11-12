#!/bin/bash

ips[0]=185.252.232.137
ips[1]=176.57.150.178
ips[2]=185.218.125.121
ips[3]=164.68.119.51
ips[4]=164.68.121.118
ips[5]=207.180.246.136
ips[6]=185.252.235.72
ips[7]=164.68.99.61
ips[8]=173.249.13.113
ips[9]=167.86.109.234
ips[10]=173.249.28.82
ips[11]=62.171.167.209
ips[12]=144.91.104.59

for val in ${ips[@]}; do
   ssh root@$val "cd vite-tools; ./remote-script.sh; ulimit -n; ulimit -Hn"
done
