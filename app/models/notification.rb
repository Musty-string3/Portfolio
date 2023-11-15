class Notification < ApplicationRecord

  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  def self.update_checked_status
    where(checked: false).update_all(checked: true)
    includes(:visited, :post).order(created_at: :desc)
  end

end
