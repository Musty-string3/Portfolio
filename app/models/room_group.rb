class RoomGroup < ApplicationRecord

  # グループチャットのアソシエーション
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups, dependent: :destroy
  has_many :message_groups, dependent: :destroy
  has_many :users, through: :message_groups, dependent: :destroy

  # バリエーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :group_description, presence: true, length: { maximum: 100 }
  validates :count, presence: true


  def include?(user)
    return false if user.nil?
    UserGroup.where(room_group_id: id, user_id: user.id).exists?
  end
end
