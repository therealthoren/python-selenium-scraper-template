# Python Selenium Scraper #TEMPLATE

### Medium Article is here:
#### coming soon

## Description
<i>Disclaimer: This repository can be cloned as a template repository and modified by your needs. It is only for educational purposes.</i>

This repository contains a DockerFile with a python app to run a selenium scraper. 

You can include your own scraper logic in the `app/scraper.py` file.

The docker container will in default run every 15minutes the scraper logic. 

After the scraper is finished your data can be sent to a webhook or you can save it by your own.

## How to use
1. Clone this repository
2. Modify the `Dockerfile` Line 18 with your cronjob time
3. Modify the `app/scraper.py` file with your own scraper logic
4. (Optional: ) Modify the `app/notifier.py` file with your own notification logic
5. Build the docker container with `sh build.sh`
6. Run the docker container with `sh run.sh`

## Screenshots

<img src="assets/screenshot1.png" style="max-width: 700px">
<br/><br/>
<img src="assets/screenshot2.png" style="max-width: 700px">


## How to watch your scraper while working
You can watch your scraper while working in the browser.

URL: `http://localhost:4444`

Password: `secret`

-----

## How to modify the Cronjob default time

### Dockerfile

```
...
# modify the cronjob time here
RUN (crontab -l ; echo "*/15 * * * * /opt/scheduler.sh >> /var/log/cron/cron-scheduled.log 2>&1") | crontab

..

```

## How to use the Webhook as result
When you want to use the webhook as result you can modify the `app/notifier.py` file with your own logic.

### app/notifier.py
```

logic = LogicController(notification=WebhookNotification("http://your-webhook-url.com/api/v1/scraper"
                                                         , only_finished=True))

```

## Log files
You can find the log files in the `/var/logs/cron/cron-scheduled.log` folder.

----

Have fun with your scraper!

## License
[MIT](https://choosealicense.com/licenses/mit/)