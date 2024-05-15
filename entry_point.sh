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
if [ "$ENABLE_PROTONVPN" = "true" ]; then
    echo "Enabling ProtonVPN"
    # write login credentials to file
    sudo bash -c "echo $PROTONVPN_USERNAME > /etc/openvpn/credentials"
    sudo bash -c "echo $PROTONVPN_PASSWORD >> /etc/openvpn/credentials"
    MY_IP=$(curl -4 icanhazip.com)
    # we iterate over the protonvpn config files and copy a random one to the openvpn directory until the
    # command 'curl -4 icanhazip.com' does not return my own ip or crashes
    while true; do
        sudo cp /etc/openvpn/protonvpn/${VPN_COUNTRY}/$(ls /etc/openvpn/protonvpn/${VPN_COUNTRY} | shuf -n 1) /etc/openvpn/client.conf
        sudo bash -c "echo 'auth-user-pass /etc/openvpn/credentials' >> /etc/openvpn/client.conf"
        sudo service openvpn start
        sleep 8
        # get the new ip and when command crashes we stop the openvpn service
        # but when the command crashes then use MY_IP as defualt to run a restart
        NEW_IP=$(curl -4 icanhazip.com || echo $MY_IP)
        # if the new ip is different from my ip, we break the loop
        if [ "$NEW_IP" != "$MY_IP" ]; then
            break
        fi
        sudo service openvpn stop
    done

fi

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