class Public::NotificationsController < ApplicationController
  def index
    my_notifications = current_user.received_notifications_from_someone
    @notifications = my_notifications.update_checked_status
  end
end
