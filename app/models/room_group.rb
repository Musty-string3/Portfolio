class RoomGroup < ApplicationRecord

  # グループチャットのアソシエーション
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups, dependent: :destroy

  # グループ名が空白＆名前が同じの場合はバリエーションエラー
  validates :name, presence: true, uniqueness: true
  validates :group_description, presence: true
  # 整数のみ許可
  validates :count, presence: true, numericality: {only_integer: true }
  # 文字数制限は2文字以上～10文字以内
  validates_inclusion_of :count, in: 2..10


end
