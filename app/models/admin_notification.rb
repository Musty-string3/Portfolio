class AdminNotification < ApplicationRecord

  belongs_to :user, foreign_key: 'visitor_id'
  belongs_to :rate, optional: true
  belongs_to :violate, optional: true

  scope :update_unchecked_rate_actions, -> {where(action: 'rate', checked: false).update_all(checked: true)}
end
