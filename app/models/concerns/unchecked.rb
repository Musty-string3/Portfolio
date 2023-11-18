module Unckecked
  extend ActiveSupport::Concern
  
  included do
    def self.unchecked_items_notifications(action)
      AdminNotification.where(action: 'rate', checked: false).count
    end
  end
end