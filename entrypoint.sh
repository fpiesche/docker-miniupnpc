#!/bin/sh

function log {
    echo " [INFO] "$1
}

function check_upnpc_status {
    if [ $1 != 0 ]; then echo " [ERROR] Failed to run upnpc command: $2"; exit 1; fi
}

if [ -z "${SERVICE_NAME}" ]; then
    log "Service name not specified, using default."
    SERVICE_NAME="Docker Service"
fi

if [ -z "${IGD_DEVICE_URL}" ]; then
    log "Trying to find IGD device..."
    IGD_DEVICE_URL=$(upnpc -L | grep -Po "(\Khttp.*.xml)")
fi
if [ -z "${IGD_DEVICE_URL}" ]; then
    log "Failed to find an IGD device on the network! Try specifying the URL using the IGD_DEVICE_URL environment variable."
    exit 1
fi

if [ -z "${LIFETIME}" ]; then
    log "Lifetime not specified; defaulting to one hour."
    LIFETIME=3600
fi

if [ -z "${TARGET_IP}" ]; then
    log "TARGET_IP environment variable not set; will show existing UPNP setup only."
else
    if [ -z "${PORTS}" ]; then
        log "Set both the PORTS and TARGET_IP variables to set up port forwards."
    else
        log "Getting current UPNP port mappings from ${IGD_DEVICE_URL}..."
        current_forwards=$(upnpc -u ${IGD_DEVICE_URL} -L)
        for external_port in $PORTS; do

            current_ip=$(echo $current_forwards | grep -Po ".*TCP\s+${external_port}->(\K[\d\.]+)")
            if [ -z ${current_ip} ]; then
                log "${SERVICE_NAME}: Port ${external_port} not currently forwarded."
            elif [ ${TARGET_IP} != ${current_ip} ]; then
                log "${SERVICE_NAME}: Port ${external_port} currently forwarded to ${current_ip}, removing..."
                upnpc_output=$(upnpc -u ${IGD_DEVICE_URL} -d ${external_port} TCP)
                check_upnpc_status $? $upnpc_output
            else
                log "${SERVICE_NAME}: Port ${external_port} correctly forwarded to ${TARGET_IP}, refreshing."
            fi
            log "${SERVICE_NAME}: Forwarding port ${external_port} to ${TARGET_IP}..."
            upnpc_output=$(upnpc -e "${SERVICE_NAME}" -u ${IGD_DEVICE_URL} -a ${TARGET_IP} ${external_port} ${external_port} TCP ${LIFETIME} "")
            check_upnpc_status $? $upnpc_output
            upnpc_output=$(upnpc -e "${SERVICE_NAME}" -u ${IGD_DEVICE_URL} -a ${TARGET_IP} ${external_port} ${external_port} UDP ${LIFETIME} "")
            check_upnpc_status $? $upnpc_output
        done
    fi
fi
