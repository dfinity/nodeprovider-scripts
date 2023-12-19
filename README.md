# nodeprovider-scripts

This repository contains useful scripts for Internet Computer Node Providers.

There are presently two scripts here: `node_monitor.sh` and `bn_connectivity.sh`

External contributions are accepted and welcomed. Pull Requests are encouraged!

# `node_monitor.sh`

This script queries the dashboard to obtain the health status of all nodes
belonging to the given node provider. It reports all unhealthy nodes.

## Usage:

1. Find your Node Provider Principal ID in the [node_list.txt](./node_list.txt) file.

2. Copy the `.env.example` file to `.env` and change it to use your Node Provider Principal ID above:

Example: `vi .env`

    NODE_PROVIDER_ID=lgp6d-brhlv-35izu-khc6p-rfszo-zdwng-xbtkh-xyvjg-y3due-7ha7t-uae

3. Run the script:

    $ ./node_monitor.sh
    All nodes are healthy

# `bn_connectivity.sh`

This script tries to ping all the boundary nodes within the region from which it
is run. It checks both IPv4 and IPv6 connectivity.
Note that for a successul node registration only IPv6 connectivity is required.

## Usage:

1. Run the script from a machine within the DC you want to test the connectivity:

    $ ./bn_connectivity.sh
    => IPv4
    Pinging 193.118.63.171
    -> successful
    Pinging 212.71.124.187
    -> successful

    => IPv6
    Pinging 2a0b:21c0:b002:2:5000:edff:fe0d:98de
    -> successful
    Pinging 2a00:fb01:400:200:5000:5aff:fef2:9428
    -> successful
    Completed connectivity check.
