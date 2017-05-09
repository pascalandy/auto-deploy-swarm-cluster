#!/usr/bin/env bash
set -u
set -e

### Load VARs | ./14_create-swarm.sh
source ./11_env.sh .

### Ensure all nodes are fully deploy before starting the process of creating our Swarm cluster
### We check if the FLAG 'node-is-configured.txt' exist on the node.
for IDaa in "${NODE_IN_THE_CLUSTER[@]}"; do

    DEPLOY_IS_DONE="False"

    until [ "$DEPLOY_IS_DONE" = "True" ]
    do
        if docker-machine ssh "$CLUSTER_NAME$IDaa"-"$SCALEWAY_REGION" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
            echo "This node is ready: " >&2
            echo "   "$CLUSTER_NAME$IDaa"-"$SCALEWAY_REGION"" >&2
            echo

            DEPLOY_IS_DONE="True"
        else
            echo "Node "$CLUSTER_NAME$IDaa"-"$SCALEWAY_REGION" is not completely deployed. Retry in 10 sec..." >&2
            sleep 10
        fi

        echo "Here are the nodes to add in the Swarm: "
        for IDbb in "${NODE_IN_THE_CLUSTER[@]}"; do
            echo "   Node: "$CLUSTER_NAME$IDbb"-"$SCALEWAY_REGION""
        done
        echo
    done
done

echo "All nodes are online."; sleep 3; echo; echo


# — — — # — — — # — — — # — — — # — — — # — — — #
### 1) Define private IP
### 2) Add the private IP into an array
### 3) Close port 22

PRIVATE_IP_CLUSTER=()

if docker-machine ssh "$NODE01" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE01" is available. Lets define its Private IP: "
    PRIVATE_IP_01=$(docker-machine ssh "$NODE01" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_01)
    docker-machine ssh $NODE01 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE01" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE02" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE02" is available. Lets define its Private IP: "
    PRIVATE_IP_02=$(docker-machine ssh "$NODE02" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_02)
    docker-machine ssh $NODE02 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE02" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE03" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE03" is available. Lets define its Private IP: "
    PRIVATE_IP_03=$(docker-machine ssh "$NODE03" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_03)
    docker-machine ssh $NODE03 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE03" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE07" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE07" is available. Lets define its Private IP: "
    PRIVATE_IP_07=$(docker-machine ssh "$NODE07" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_07)
    docker-machine ssh $NODE07 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE07" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE08" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE08" is available. Lets define its Private IP: "
    PRIVATE_IP_08=$(docker-machine ssh "$NODE08" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_08)
    docker-machine ssh $NODE08 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE08" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE09" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE09" is available. Lets define its Private IP: "
    PRIVATE_IP_09=$(docker-machine ssh "$NODE09" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_09)
    docker-machine ssh $NODE09 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE09" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE11" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE11" is available. Lets define its Private IP: "
    PRIVATE_IP_11=$(docker-machine ssh "$NODE11" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_11)
    docker-machine ssh $NODE11 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE11" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE12" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE12" is available. Lets define its Private IP: "
    PRIVATE_IP_12=$(docker-machine ssh "$NODE12" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_12)
    docker-machine ssh $NODE12 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE12" is not online. Private IP not defined." >&2
    echo
fi
if docker-machine ssh "$NODE13" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo ""$NODE13" is available. Lets define its Private IP: "
    PRIVATE_IP_13=$(docker-machine ssh "$NODE13" -p997 ifconfig eth0| grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
    PRIVATE_IP_CLUSTER+=($PRIVATE_IP_13)
    docker-machine ssh $NODE13 -p997 "ufw deny 22; ufw --force enable; ufw reload"
else
    echo ""$NODE13" is not online. Private IP not defined." >&2
    echo
fi

echo; echo "The private IP to add to our UFW rules are: "
echo "$PRIVATE_IP_CLUSTER"; echo

# — — — # — — — # — — — # — — — # — — — # — — — #
### UFW | Allow access within private networks
echo "The private IP to add to our UFW rules are: "
for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
    echo $ACTION_ADD_IP
done; echo


if docker-machine ssh "$NODE01" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE01" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE01 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE01" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE02" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE02" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE02 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE02" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE03" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE03" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE03 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE03" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE07" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE07" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE07 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE07" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE08" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE08" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE08 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE08" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE09" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE09" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE09 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE09" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE11" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE11" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE11 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE11" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE12" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE12" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE12 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE12" is not online. No UFW rule to configure." >&2
    echo
fi
if docker-machine ssh "$NODE13" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    for ACTION_ADD_IP in "${PRIVATE_IP_CLUSTER[@]}"; do
        echo ""$NODE13" is available. Configure UFW and our Private IPs: "
        docker-machine ssh $NODE13 -p997 "ufw allow from $ACTION_ADD_IP; ufw --force enable; ufw reload"
        echo
    done
else
    echo ""$NODE13" is not online. No UFW rule to configure." >&2
    echo
fi


# — — — # — — — # — — — # — — — # — — — # — — — #
### Initialize the first Swarm Leaders and Tokens
echo "Initialize the first Swarm Leaders and Tokens: "
docker-machine ssh $NODE01 -p997 \
    "docker swarm init \
    --listen-addr "$PRIVATE_IP_01" \
    --advertise-addr "$PRIVATE_IP_01""

### Export tokens
echo "Exporting tokens: "
worker_token=$(docker-machine ssh $NODE01 -p997 "docker swarm join-token worker -q")
manager_token=$(docker-machine ssh $NODE01 -p997 "docker swarm join-token manager -q")
echo; echo

# — — — # — — — # — — — # — — — # — — — # — — — #
### Add Swarm Leaders
# — — — # — — — # — — — # — — — # — — — # — — — #

if docker-machine ssh "$NODE02" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE02" as a LEADER: " >&2
    docker-machine ssh "$NODE02" -p997 \
    "docker swarm join \
        --token=$manager_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_02"
else
    echo ""$NODE02" is not online. Not joining as a LEADER" >&2
    sleep 2; echo
fi

if docker-machine ssh "$NODE03" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE03" as a LEADER: " >&2
    docker-machine ssh "$NODE03" -p997 \
    "docker swarm join \
        --token=$manager_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_03"
else
    echo ""$NODE03" is not online. Not joining as a LEADER" >&2
    sleep 2; echo
fi

# — — — # — — — # — — — # — — — # — — — # — — — #
### Add Swarm Workers
# — — — # — — — # — — — # — — — # — — — # — — — #
if docker-machine ssh "$NODE07" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE07" as a WORKER: " >&2
    docker-machine ssh "$NODE07" -p997 \
    "docker swarm join \
        --token=$worker_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_07"
else
    echo ""$NODE07" is not online. Not joining as a WORKER" >&2
    sleep 2; echo
fi

if docker-machine ssh "$NODE08" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE08" as a WORKER: " >&2
    docker-machine ssh "$NODE08" -p997 \
    "docker swarm join \
        --token=$worker_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_08"
else
    echo ""$NODE08" is not online. Not joining as a WORKER" >&2
    sleep 2; echo
fi

if docker-machine ssh "$NODE09" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE09" as a WORKER: " >&2
    docker-machine ssh "$NODE09" -p997 \
    "docker swarm join \
        --token=$worker_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_09"
else
    echo ""$NODE09" is not online. Not joining as a WORKER" >&2
    sleep 2; echo
fi

if docker-machine ssh "$NODE11" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE11" as a WORKER: " >&2
    docker-machine ssh "$NODE11" -p997 \
    "docker swarm join \
        --token=$worker_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_11"
else
    echo ""$NODE11" is not online. Not joining as a WORKER" >&2
    sleep 2; echo
fi

if docker-machine ssh "$NODE12" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE12" as a WORKER: " >&2
    docker-machine ssh "$NODE12" -p997 \
    "docker swarm join \
        --token=$worker_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_12"
else
    echo ""$NODE12" is not online. Not joining as a WORKER" >&2
    sleep 2; echo
fi

if docker-machine ssh "$NODE13" -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then
    echo "Joining "$NODE13" as a WORKER: " >&2
    docker-machine ssh "$NODE13" -p997 \
    "docker swarm join \
        --token=$worker_token $PRIVATE_IP_01:2377 \
        --advertise-addr $PRIVATE_IP_13"
else
    echo ""$NODE13" is not online. Not joining as a WORKER" >&2
    sleep 2; echo
fi


### Confirm everthing work as expected
echo "Swarm cluster is created!"
docker-machine ssh "$NODE01" -p997 "docker node ls"