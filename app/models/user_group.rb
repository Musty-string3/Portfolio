class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :room_group
end
