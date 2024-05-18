#!/usr/bin/env bash

#==============================================
# OpenShift or non-sudo environments support
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
#==============================================

# added for tor
# check if "ENABLE_TOR" is set to "true"
if [ "$ENABLE_TOR" = "true" ]; then
    echo "Enabling Tor"
    # start tor
    sudo service tor start
    # start privoxy
    sudo service privoxy start
fi

# check if ENABLE_PROTONVPN is set to "true"
sh /opt/change_vpn.sh

### added for cronjob
sudo service cron stop
sudo service cron reload
sudo service cron start

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

/usr/bin/supervisord --configuration /etc/supervisord.conf &

SUPERVISOR_PID=$!

function shutdown {
    echo "Trapped SIGTERM/SIGINT/x so shutting down supervisord..."
    kill -s SIGTERM ${SUPERVISOR_PID}
    wait ${SUPERVISOR_PID}
    echo "Shutdown complete"
}

trap shutdown SIGTERM SIGINT
wait ${SUPERVISOR_PID}