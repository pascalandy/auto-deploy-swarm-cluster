#!/usr/bin/env bash
set -u
set -e

### Load VARs | ./11_N01_provision.sh
source ./11_env.sh .

### Define VAR for this script
THIS_NODE=$NODE02

### Deploy nodes on Scaleway
docker-machine create -d scaleway \
    --scaleway-region="$SCALEWAY_REGION" \
    --scaleway-image="$DOCKER_IMAGE" \
     --scaleway-token="$SCALEWAY_TOKEN" \
    --scaleway-organization="$SCALEWAY_ORGANIZATION" \
    --scaleway-commercial-type="$SCALEWAY_COMMERCIAL_TYPE" \
    --scaleway-name="$THIS_NODE" "$THIS_NODE"
	
echo; echo "Node $THIS_NODE is delpoyed via Docker Machine. Time to configure it"; echo; echo; sleep 2

# Create bkp-mysql DIR on each nodes
echo "Create main directories"
docker-machine ssh $THIS_NODE "mkdir -p /mnt/bkp-mysql/mysql-dump"
docker-machine ssh $THIS_NODE "mkdir -p /mnt/bkp-mysql/mysql-xtrabackup"
docker-machine ssh $THIS_NODE "mkdir -p /mnt/resilio000/$CLUSTER_NAME"

### Run all the configs on the server
docker-machine ssh $THIS_NODE "mkdir -p ~/temp; cd ~/temp; wget $config_scaleway_url"
docker-machine ssh $THIS_NODE "cd ~/temp; chmod +x 12_server_config_script.sh"

echo; echo "Be patient, the terminal will not send feedback for while here: "; echo
docker-machine ssh $THIS_NODE "cd ~/temp; ./12_server_config_script.sh;" > /dev/null 2>&1 || true
sleep 5; echo "reboot"
docker-machine ssh $THIS_NODE "sudo reboot" > /dev/null 2>&1 || true

echo "$THIS_NODE is restarting. Wait 20 sec."
sleep 20

### Ensure our nodes are fully deploy before creating our Swarm cluster
DEPLOY_IS_DONE="False"

until [ "$DEPLOY_IS_DONE" = "True" ]
do
    if docker-machine ssh $THIS_NODE -p997 "[ -f "~/temp/node-is-configured.txt" ]" 2> /dev/null; then

        docker-machine ssh $THIS_NODE -p997 "echo "checkpoint 124 $(date +%Y-%m-%d_%Hh%Mm%S) $THIS_NODE" >> ~/temp/provisionninglogs.txt"
        docker-machine ssh $THIS_NODE -p997 "cat ~/temp/provisionninglogs.txt"
        echo
        echo "$THIS_NODE has restarted. Ready to join the Swarm"
        DEPLOY_IS_DONE="True"
    else
        echo "Node "$THIS_NODE" is still restarting. Retry in 5 sec..." >&2
        sleep 5
    fi
done

### UFW | Open public port (shall be on 3 worker nodes (N11, N12, N13) only)
echo; echo "No need to open public ports on this node."
docker-machine ssh $THIS_NODE -p997 "ufw status numbered"
echo