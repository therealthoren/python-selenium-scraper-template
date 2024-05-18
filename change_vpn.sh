#!/usr/bin/env bash

# check if ENABLE_PROTONVPN is set to "true"
if [ "$ENABLE_PROTONVPN" = "true" ]; then
    sudo service openvpn stop
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
        # add ignore local traffic of example for kubernetes
        # sudo bash -c "echo 'route 10.233.0.0 255.255.0.0 net_gateway' >> /etc/openvpn/client.conf"
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