#!/usr/bin/env bash
set -u
set -e

### Node specs
CLUSTER_NAME="ALPHA"
NODE_IN_THE_CLUSTER=(01 02 03 11)

SCALEWAY_REGION="par1"
DOCKER_IMAGE="ubuntu-xenial"
SCALEWAY_COMMERCIAL_TYPE="VC1S"

### Define which nodes will be included our Swarm cluster

NODE01="$CLUSTER_NAME"01-"$SCALEWAY_REGION"
NODE02="$CLUSTER_NAME"02-"$SCALEWAY_REGION"
NODE03="$CLUSTER_NAME"03-"$SCALEWAY_REGION"
NODE07="$CLUSTER_NAME"07-"$SCALEWAY_REGION"
NODE08="$CLUSTER_NAME"08-"$SCALEWAY_REGION"
NODE09="$CLUSTER_NAME"09-"$SCALEWAY_REGION"
NODE11="$CLUSTER_NAME"11-"$SCALEWAY_REGION"
NODE12="$CLUSTER_NAME"12-"$SCALEWAY_REGION"
NODE13="$CLUSTER_NAME"13-"$SCALEWAY_REGION"

    # When those are defined, launch the creation of each nodes via ./deploy-NXX.sh
    # We do this in order to provision nodes in PARALLEL, else it's too long :)
    # Launch ./swarm-create.sh . It will ensure all nodes are deployed then configure them as a Swarm Cluster.

### Flag used to ensure the node is ready to join the swarm
FLAG_DEPLOYED="/temp/node-is-configured.txt"

### Private tokens
#_SENSITIVE_DATA
SCALEWAY_TOKEN="#_SENSITIVE_DATA#_SENSITIVE_DATA"
SCALEWAY_ORGANIZATION="#_SENSITIVE_DATA#_SENSITIVE_DATA"

### config-scaleway | gist url from 12_ubuntu-configs.sh
# SENSITIVE_DATA
config_scaleway_url="#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA"