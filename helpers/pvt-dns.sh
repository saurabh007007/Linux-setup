#!/bin/bash

# Fetch the active connection name
CONNECTION_NAME=$(nmcli -t -f NAME,TYPE connection show --active | grep ethernet | cut -d: -f1)

# Check if the connection name was found
if [ -z "$CONNECTION_NAME" ]; then
    echo "No active Ethernet connection found."
    exit 1
fi

# Print the fetched connection name
echo "Active Ethernet connection name: $CONNECTION_NAME"

# Define the IPv4 DNS servers
IPV4_DNS1="76.76.2.42"
IPV4_DNS2="76.76.10.42"

# Define the IPv6 DNS servers
IPV6_DNS1="2606:1a40::42"
IPV6_DNS2="2606:1a40:1::42"

# Set the IPv4 DNS servers
sudo nmcli connection modify "$CONNECTION_NAME" ipv4.dns "$IPV4_DNS1, $IPV4_DNS2" ipv4.ignore-auto-dns yes

# Set the IPv6 DNS servers
sudo nmcli connection modify "$CONNECTION_NAME" ipv6.dns "$IPV6_DNS1, $IPV6_DNS2" ipv6.ignore-auto-dns yes

# Restart the network connection
sudo nmcli connection down "$CONNECTION_NAME"
sudo nmcli connection up "$CONNECTION_NAME"

# Verify the DNS settings
nmcli dev show | grep DNS

echo "DNS configuration has been updated for connection: $CONNECTION_NAME."
