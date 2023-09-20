class RoomGroup < ApplicationRecord
  belongs_to :user
  
  # グループチャットのアソシエーション
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  
  # グループ名が空白＆名前が同じの場合はバリエーションエラー
  validates :name, presence: true, uniqueness: true
  validates :group_description, presence: true
end
