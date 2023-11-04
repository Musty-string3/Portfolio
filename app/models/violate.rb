class Violate < ApplicationRecord
  belongs_to :reporter, class_name: 'User', foreign_key: 'reporter_id'  # 報告したユーザー
  belongs_to :reported, class_name: 'User', foreign_key: 'reported_id'  # 報告されたユーザー
  belongs_to :post

  # 管理者通知のアソシエーション
  has_many :admin_notifications, dependent: :destroy

  validates :status, presence: true

  enum status: { inappropriate: 0, copyright_violation: 1, slander: 2, others: 3}
  # 0 = 不正、不適切な投稿, 1 = 著作権違反, 2 = 誹謗中傷、悪口, 3 = その他

  def self.find?(current_user, reported, post, status)
    find_by(
      reporter_id: current_user.id,
      reported_id: reported,
      post_id: post,
      status: status
    )
  end

  # 違反報告の通知の作成
  def create_notification_violate!(current_user)
    temp = AdminNotification.find_by(visitor_id: current_user.id, violate_id: id, action: 'violate')
    if temp.nil?
      current_user.admin_notifications.create(
        violate_id: id,
        action: 'violate'
      )
    end
  end

  # 未確認通知のカウント
  def self.unchecked_violate_notifications
    AdminNotification.where(action: 'violate', checked: false).count
  end
end
