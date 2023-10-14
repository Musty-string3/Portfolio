class MessageGroup < ApplicationRecord
  belongs_to :user
  belongs_to :room_group

  validates :text, presence: true

  delegate :get_profile_image, to: :user
end
