#!/usr/bin/env bash
set -u
set -e

### Load VARs | ./17_list-nodes.sh
source ./11_env.sh .

### See available nodes
echo "Show all via docker-machine ls"
echo "docker-machine rm -f XY"; echo

docker-machine ls
echo && echo

echo "Show all via scw ps"
scw ps
echo && echo

echo "Show this active cluster"
docker-machine ls | grep "$CLUSTER_NAME"
echo && echo