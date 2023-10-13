class Rate < ApplicationRecord

  belongs_to :user

  # 管理者通知のアソシエーション
  has_many :admin_notifications, dependent: :destroy

  with_options presence: true do
    validates :user
    validates :star
  end

  # レビュー通知の作成
  def create_notification_rate!(current_user)
    AdminNotification.find_or_create_by(visitor_id: current_user.id, rate_id: id, action: 'rate')
  end

  # 未確認通知のカウント
  def self.unchecked_rates_notifications
    AdminNotification.where(action: 'rate', checked: false).count
  end
end