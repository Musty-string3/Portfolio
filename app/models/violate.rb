class Violate < ApplicationRecord
  belongs_to :reporter, class_name: 'User', foreign_key: 'reporter_id'  # 報告したユーザー
  belongs_to :reported, class_name: 'User', foreign_key: 'reported_id'  # 報告されたユーザー
  belongs_to :post

  # 管理者通知のアソシエーション
  has_many :admin_notifications, dependent: :destroy

  validates :status, presence: true

  enum status: { inappropriate: 0, copyright_violation: 1, slander: 2}
  # 0 = 不正、不適切な投稿, 1 = 著作権違反, 2 = 誹謗中傷、悪口

  def create_notification_violate!(current_user)
    temp = AdminNotification.find_by(visitor_id: current_user.id, violate_id: id, action: 'violate')
    if temp.nil?
      current_user.admin_notifications.create!(
        violate_id: id,
        action: 'violate'
      )
    end
  end
end
