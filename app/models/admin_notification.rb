class AdminNotification < ApplicationRecord

  belongs_to :user, foreign_key: 'visitor_id'
  belongs_to :rate, optional: true
  belongs_to :violate, optional: true

  def self.update_unchecked_actions(action)
    where(action: action, checked: false).update_all(checked: true)
  end
  
  # TODO明日の質問内容　重複してる
  class Rate < ApplicationRecord
    def self.unchecked_items_notifications(action)
      AdminNotification.where(action: action, checked: false).count
    end
  end
  
  class Violate < ApplicationRecord
    def self.unchecked_items_notifications(action)
      AdminNotification.where(action: action, checked: false).count
    end
  end
  
end