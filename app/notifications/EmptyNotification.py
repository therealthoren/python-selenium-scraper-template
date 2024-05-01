from app.notifications.INotification import INotification


class EmptyNotification(INotification):
    def finished(self, data):
        print(data)

    def crashed(self, e=None):
        print(("Crashed: " + str(e)) if e is not None else "Crashed")

    def start(self, message=None):
        print(("Started: " + str(message)) if message is not None else "Started")

    def message(self, param):
        print("Message: " + param)