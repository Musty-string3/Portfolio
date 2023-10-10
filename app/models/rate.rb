class Rate < ApplicationRecord

  belongs_to :user

  # 管理者通知のアソシエーション
  has_many :admin_notifications, dependent: :destroy

  with_options presence: true do
    validates :user
    validates :star
  end
end
