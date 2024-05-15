#!/bin/bash

# ask for protonvpn username
echo "Enter your ProtonVPN username:"
read PROTONVPN_USERNAME

# ask for protonvpn password
echo "Enter your ProtonVPN password:"
read PROTONVPN_PASSWORD

# ask for protonvpn country
echo "Enter the country you want to connect to: (nl,jp,us)"
read VPN_COUNTRY

docker run -d --privileged -p 4444:4444 -p 7900:7900 --shm-size="2g" -e ENABLE_PROTONVPN=true -e PROTONVPN_USERNAME=$PROTONVPN_USERNAME -e PROTONVPN_PASSWORD=$PROTONVPN_PASSWORD -e VPN_COUNTRY=$VPN_COUNTRY python-selenium-scraper-template