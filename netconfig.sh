#!/bin/bash

ip addr add 192.168.1.20/24 dev ens3
ip link set up dev ens3
ip route add default via 192.168.1.1
