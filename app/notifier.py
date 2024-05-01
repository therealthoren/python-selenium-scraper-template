from app.logic.LogicController import LogicController
from app.notifications.EmptyNotification import EmptyNotification
from app.notifications.WebhookNotification import WebhookNotification

##########
# Notification Logic
##########
# If you want to use Webhooks as notification, use the following line
# TODO: Change the Webhook URL to your URL or Implement your own notification logic for receiving the data
####
# logic = LogicController(notification=WebhookNotification("http://your-scraped-data-receiver-url.com/endpoint"
#                                                         , only_finished=True))
####

# Usually you want to use the EmptyNotification, which just prints the data to the console and you
# have to save the scraped data by yourself
logic = LogicController(notification=EmptyNotification())