class Violate < ApplicationRecord
  belongs_to :reporter, class_name: 'User'  # 報告したユーザー
  belongs_to :reported, class_name: 'User'  # 報告されたユーザー
  belongs_to :user
  belongs_to :post

  enum status: { inappropriate: 0, copyright_violation: 1, slander: 2}
  # 0 = 不正、不適切な投稿, 1 = 著作権違反, 2 = 誹謗中傷、悪口
end
