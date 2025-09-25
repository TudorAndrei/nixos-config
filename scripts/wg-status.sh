#!/bin/bash

# Check if WireGuard service is active
if systemctl is-active --quiet wireguard-wg0.service; then
    echo '{"text":"󰖂","tooltip":"WireGuard: Active - Click to open UI"}'
else
    echo '{"text":"󰖂","tooltip":"WireGuard: Inactive - Click to open UI","class":"disconnected"}'
fi
