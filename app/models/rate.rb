class Rate < ApplicationRecord
  include Sortable

  belongs_to :user
  has_many :admin_notifications, dependent: :destroy

  with_options presence: true do
    validates :user
    validates :star
  end

  def self.count_unchecked_notifications
    AdminNotification.where(action: 'rate', checked: false).count
  end

  def create_notification_rate!(current_user)
    AdminNotification.find_or_create_by(visitor_id: current_user.id, rate_id: id, action: 'rate')
  end
end