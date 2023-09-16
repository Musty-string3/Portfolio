class Public::NotificationsController < ApplicationController
  def index
    notifications = current_user.other_notifications.where.not(visitor_id: current_user.id)
    notifications.update_all(checked: true)
    @notifications = notifications.includes(:visited, :post).order(created_at: :desc)
  end
end
