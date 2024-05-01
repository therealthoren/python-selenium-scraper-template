FROM selenium/standalone-firefox:latest

USER root

RUN apt update
RUN apt install -y python3-pip python3-dev build-essential

RUN apt install cron -y && apt install vim -y

RUN mkdir /var/log/cron/
RUN chmod 777 /var/log/cron/

USER seluser

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


EXPOSE 4444 7900 5900

COPY entry_point.sh /opt/bin/entry_point.sh
RUN sudo chmod +x /opt/bin/entry_point.sh
RUN sudo chmod 777 /opt/bin/entry_point.sh
