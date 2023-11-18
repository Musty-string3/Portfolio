# require './app/models/concerns/unchecked'
class Rate < ApplicationRecord
  # include Unchecked
  include Sortable

  def self.unchecked_items_notifications(action)
    AdminNotification.where(action: action, checked: false).count
  end

  belongs_to :user
  has_many :admin_notifications, dependent: :destroy

  with_options presence: true do
    validates :user
    validates :star
  end

  def create_notification_rate!(current_user)
    AdminNotification.find_or_create_by(visitor_id: current_user.id, rate_id: id, action: 'rate')
  end
end