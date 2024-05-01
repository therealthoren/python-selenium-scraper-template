from app.notifications import INotification
from app.notifications.WebhookNotification import WebhookNotification

import os

class LogicController:
    _notification : INotification = None
    def __init__(self, notification: INotification):
        self._notification = notification

    def crashed(self, e=None):
        self._notification.crashed(e)

    def finished(self, data):
        self._notification.finished(data)

    def start(self, message=None):
        self._notification.start(message)

    def message(self, param):
        self._notification.message(param)

    def quit_docker(self):
        os.system("docker stop $(docker ps -a -q)")

    def set_quit_docker_after_finish(self, param):
        self._quit_docker_after_finish = param

    def close_or_quite(self):
        if self._quit_docker_after_finish:
            self.quit_docker()
