#!/bin/bash
set -eo pipefail

# This script allows node providers to quickly check if they can reach
# all the boundary nodes from their region.
# It does so by pinging all boundary nodes in the region both on IPv4 and IPv6.
# However, for a succesful node registration only IPv6 is required.

domain="ic0.app"

# Perform DNS lookup for IPv4 and IPv6 addresses
ipv4_addresses=($(dig A $domain +short))
ipv6_addresses=($(dig AAAA $domain +short))

# ANSI color codes
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'  # No color

function ping_address {
    ping_cmd=$1
    address=$2
    echo -e "Pinging $address"
    if $ping_cmd -c 4 $address > /dev/null 2>&1; then
        echo -e "${green}-> successful${nc}"
    else
        echo -e "${red}-> failed${nc}"
    fi
}

# Check IPv4 connectivity to the boundary nodes
echo "=> IPv4"
if [ ${#ipv4_addresses[@]} -gt 0 ]; then
    for address in "${ipv4_addresses[@]}"; do
        ping_address ping $address
    done
else
    echo -e "${red}No IPv4 addresses found.${nc}"
    exit 1
fi
echo ""

# Check IPv6 connectivity to the boundary nodes
echo "=> IPv6"
if [ ${#ipv6_addresses[@]} -gt 0 ]; then
    for address in "${ipv6_addresses[@]}"; do
        ping_address ping6 $address
    done
else
    echo -e "${red}No IPv6 addresses found.${nc}"
    exit 1
fi

echo -e "Completed connectivity check."
