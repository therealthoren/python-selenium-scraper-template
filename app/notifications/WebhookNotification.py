import datetime
from app.notifications.INotification import INotification
import logging as log
import requests

log.basicConfig(level=log.INFO)

class WebhookNotification(INotification):
    webhook = None
    startWebhook = None
    crashedWebhook = None
    messageWebhook = None
    only_finished = False

    def __init__(self, webhook, startWebhook=None, crashedWebhook=None, messageWebhook=None, only_finished=False):
        self.webhook = webhook
        self.startWebhook = startWebhook
        self.crashedWebhook = crashedWebhook
        self.messageWebhook = messageWebhook
        self.only_finished = only_finished

    def finished(self, data):
        data = {
                "data": data,
                "status": "finished",
                "datetime": self.get_current_datetime()
            }
        self.send(data)

    def get_current_datetime(self):
        return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def crashed(self, e=None):
        try:
            log.error(("Crashed: " + str(e)) if e is not None else "Crashed")
        except Exception as e:
            log.error("Error in logging: " + str(e))
        data = {
                "error": e,
                "status": "crashed",
                "datetime": self.get_current_datetime()
            }

        if not self.only_finished:
            if self.crashedWebhook is not None:
                self.send( data, self.crashedWebhook)
            else:
                self.send(data)

    def send(self, data, webhook=None):
        if webhook is None:
            webhook = self.webhook
        try:
            response = requests.post(webhook, json=data)
            if response.status_code == 200:
                log.debug("Data sent to webhook: " + str(data))
            else:
                log.error("Error sending data to webhook: " + str(response.status_code)+ " " + str(response.text))
        except Exception as e:
            log.error("Error sending data to webhook: " + str(e))

    def start(self, message=None):
        log.info(("Started: " + str(message)) if message is not None else "Started")
        data = {
                "message": message,
                "status": "started",
                "datetime": self.get_current_datetime()
            }
        if not self.only_finished:
            if self.startWebhook is not None:
                self.send(data, self.startWebhook)
            else:
                self.send(data)

    def message(self, param):
        log.info("Message: " + param)
        data = {
                "message": param,
                "status": "message",
                "datetime": self.get_current_datetime()
            }

        if not self.only_finished:
            if self.messageWebhook is not None:
                self.send(data, self.messageWebhook)
            else:
                self.send(data)