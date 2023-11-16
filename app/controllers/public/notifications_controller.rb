class Public::NotificationsController < ApplicationController
  def index
    my_notifications = current_user.other_notifications.where.not(visitor_id: current_user.id)
    @notifications = my_notifications.update_checked_status
  end
end
