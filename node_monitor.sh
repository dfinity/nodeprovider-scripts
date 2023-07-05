#!/bin/bash 
set -eo pipefail

# Queries the IC Dashboard API to retrieve down nodes per node provider
# Requires a .env file with 
#   NODE_PROVIDER_ID=NODE_PROVIDER_PRINCIPAL_ID
# Logic can be added to send email alerts
PRINCIPAL_ID_REGEX="^([a-zA-Z0-9]{5}-){10}[a-zA-Z0-9]{3}$"

# Check for .env file, prompt to create one if missing.
if [ ! -f "./.env" ]; then
    printf "Missing .env file.  Please enter your Principal ID: "
    read NODE_PROVIDER_ID
    if [[ ! ${NODE_PROVIDER_ID} =~ ${PRINCIPAL_ID_REGEX} ]]; then
        printf "\nInvalid Principal ID.  Please contact support, or check your Principal ID at\n"
        printf "https://dashboard.internetcomputer.org/providers\n"
        exit 1
    fi
    echo "NODE_PROVIDER_ID=${NODE_PROVIDER_ID}" > .env
fi

# Source .env file for variables.
source ./.env
if [ -z "${NODE_PROVIDER_ID}" ]; then
    printf ".env file must contain NODE_PROVIDER_ID=\n"
    exit 1
fi

# Check for jq runtime installed
if ! command -v jq &>/dev/null; then
    printf "Missing jq runtime\n"
    printf "https://stackoverflow.com/questions/37668134/how-to-install-jq-on-mac-on-the-command-line\n"
    exit 1
fi

# Check for curl runtime installed
if ! command -v curl &>/dev/null; then
    printf "Missing curl runtime\n"
    exit 1
fi

# Pull the node provider identities from the IC Dashboard API
TEMP_FILE="node_list.txt"
API="https://ic-api.internetcomputer.org/api/v3/nodes?node_provider_id=${NODE_PROVIDER_ID}"

RESPONSE=$(curl -s -o ${TEMP_FILE} -w "%{http_code}" ${API})

if [ ${RESPONSE} != "200" ]; then
    printf "That didn't work, please verify your Principal ID and try again\n"
    exit 1
fi

NODE_LIST=$(cat ${TEMP_FILE} | jq '.nodes | map(select(.status!="UP"))')
NODE_COUNT=$(echo ${NODE_LIST} | jq length)

# If all nodes are healthy, exit with 0
if [ ${NODE_COUNT} == 0 ]; then
    printf "All nodes are healthy\n"
    exit 0
fi

# If unhealthy nodes are found, print them out and exit with 2
echo ${NODE_LIST} | jq -c .[] | while read NODE; do
    # Add additional logic here to send emails or Pager Duty APIs
    node_id=$(jq -r '.node_id' <<< ${NODE});
    dc_name=$(jq -r '.dc_name' <<< ${NODE});
    dc_id=$(jq -r '.dc_id' <<< ${NODE});
    status=$(jq -r '.status' <<< ${NODE});
    printf "${node_id} in ${dc_name} (${dc_id}) is ${status}\n"
done

exit 2
