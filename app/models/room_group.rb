class RoomGroup < ApplicationRecord

  # グループチャットのアソシエーション
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups, dependent: :destroy
  has_many :message_groups, dependent: :destroy
  has_many :users, through: :message_groups, dependent: :destroy

  # バリエーション
  validates :name, presence: true, uniqueness: true # グループ名が空白＆名前が同じの場合はバリエーションエラー
  validates :group_description, presence: true
  validates :count, presence: true, numericality: {only_integer: true } # 整数のみ許可
  validates_inclusion_of :count, in: 3..10  # 文字数制限は2文字以上～10文字以内


  def include?(user)
    return false if user.nil?
    UserGroup.where(room_group_id: id, user_id: user.id).exists?
  end
end
