class Rate < ApplicationRecord
  include Sortable  # app/models/concerns/sortable.rbが使える

  belongs_to :user
  has_many :admin_notifications, dependent: :destroy

  with_options presence: true do
    validates :user
    validates :star
  end

  def create_notification_rate!(current_user)
    AdminNotification.find_or_create_by(visitor_id: current_user.id, rate_id: id, action: 'rate')
  end

  def self.unchecked_rates_notifications
    AdminNotification.where(action: 'rate', checked: false).count
  end
end
