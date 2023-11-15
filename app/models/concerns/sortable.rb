module Sortable
  extend ActiveSupport::Concern
  included do
    scope :for_users_created_desc, -> {includes(:user).all.order(created_at: :desc)}
  end
end