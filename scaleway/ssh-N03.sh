#!/usr/bin/env bash
set -u
set -e

### Load VARs | ./15_ssh_N01.sh
source ./11_env.sh .

### Define Var for this script
THIS_NODE=$NODE03

### Access this node
docker-machine ssh $THIS_NODE -p997
    # another way
    #ssh root@$(scw ps | grep $THIS_NODE | awk '{print $7}') -p997