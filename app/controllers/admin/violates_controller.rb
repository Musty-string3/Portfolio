class Admin::ViolatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @violates = Violate.includes(:post).all.order(created_at: :desc)
    # 未確認の通知を確認済みにする
    @violates.where(checked: false).update_all(checked: true)
    # 違反一覧画面に遷移したときに全て既読にする
    AdminNotification.where(action: 'violate', checked: false).update_all(checked: true)
  end
end
