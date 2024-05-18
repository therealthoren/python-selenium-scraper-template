FROM selenium/standalone-firefox:latest

USER root

ENV VPN_COUNTRY=nl
ENV ENABLE_PROTONVPN=false
ENV ENABLE_TOR=false

RUN apt update
RUN apt install -y python3-pip python3-dev build-essential

RUN apt install cron -y && apt install vim -y

# install tor
RUN apt install tor tor-geoipdb privoxy -y
# install tor as a service
COPY torrc /etc/tor/torrc
COPY privoxy.conf /etc/privoxy/config

# install protonvpn
RUN apt install openvpn openresolv -y
RUN sudo wget "https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh" -O "/etc/openvpn/update-resolv-conf"
RUN sudo chmod +x /etc/openvpn/update-resolv-conf

# install openvpn and config
COPY proton_vpn /etc/openvpn/protonvpn

# install cron
RUN mkdir /var/log/cron/
RUN chmod 777 /var/log/cron/

USER seluser

COPY change_vpn.sh /opt/change_vpn.sh
RUN sudo chmod +x /opt/change_vpn.sh

COPY scheduler.sh /opt/scheduler.sh
RUN sudo chmod +x /opt/scheduler.sh

RUN (crontab -l ; echo "*/15 * * * * /opt/scheduler.sh >> /var/log/cron/cron-scheduled.log 2>&1") | crontab

# copy the python script
COPY app /opt/app
COPY main.py /opt/main.py

# Install python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt


# create a scheduled service
EXPOSE 4444 7900


COPY entry_point.sh /opt/bin/entry_point.sh
RUN sudo chmod +x /opt/bin/entry_point.sh
RUN sudo chmod 777 /opt/bin/entry_point.sh
