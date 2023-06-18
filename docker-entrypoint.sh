#!/bin/sh

privoxy /etc/privoxy/config
exec ss-local -s $SERVER_ADDR -p $SERVER_PORT -k ${PASSWORD} -m $METHOD -t $TIMEOUT -l $LOCAL_PORT $ARGS