#!/bin/bash

echo "[HOOK] setting HOST_HOSTNAME to $(hostname) in $(pwd)/host.env" >> /var/log/eb-engine.log
echo "HOST_HOSTNAME=$(hostname)" > "host.env"
