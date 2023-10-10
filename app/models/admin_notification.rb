class AdminNotification < ApplicationRecord
  belongs_to :user, foreign_key: 'visitor_id'
  belongs_to :rate, optional: true
  belongs_to :violate, optional: true
end
