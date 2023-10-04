class Violate < ApplicationRecord
  belongs_to :reporter, calss_name: 'User'  # 報告したユーザー
  belongs_to :reported, calss_name: 'User'  # 報告されたユーザー
  belongs_to :user
  belongs_to :post
end
