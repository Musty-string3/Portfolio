class Public::NotificationsController < ApplicationController
  def index
    @notifications = current_user.other_notifications
    @nocurrent_user_notifications = @notifications.where.not(visitor_id: current_user.id).order(created_at: :desc)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
