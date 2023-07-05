# nodeprovider-scripts

This repository contains useful scripts for Internet Computer Node Providers.

There is presently only one script here: `node_monitor.sh`

Pull Requests are welcomed!


# Usage:

1. Find your Node Provider Principal ID in the [node_list.txt](./node_list.txt) file.

2. Copy the `.env.example` file to `.env` and change it to use your Node Provider Principal ID above:

Example: `vi .env`

    NODE_PROVIDER_ID=lgp6d-brhlv-35izu-khc6p-rfszo-zdwng-xbtkh-xyvjg-y3due-7ha7t-uae

3. Run the script:

    $ ./node_monitor.sh
    All nodes are healthy

