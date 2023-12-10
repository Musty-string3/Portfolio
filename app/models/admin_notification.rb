class AdminNotification < ApplicationRecord

  belongs_to :user, foreign_key: 'visitor_id'
  belongs_to :rate, optional: true
  belongs_to :violate, optional: true

  def self.update_unchecked_actions(action)
    where(action: action, checked: false).update_all(checked: true)
  end

end