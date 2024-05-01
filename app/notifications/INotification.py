
# python interface for the notification system
class INotification:
    def __init__(self):
        pass

    def finished(self, data):
        raise NotImplementedError()

    def crashed(self, e=None):
        raise NotImplementedError()

    def start(self, message=None):
        raise NotImplementedError()

    def message(self, param):
        raise NotImplementedError()


