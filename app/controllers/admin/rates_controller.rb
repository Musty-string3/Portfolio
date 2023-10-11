class Admin::RatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rate = Rate.includes(:user).all.order(created_at: :desc)
    # 平均点を整数で求める
    @average_rate = Rate.average(:star).to_i
    # レビュ一覧画面に遷移したときに全て既読にする
    AdminNotification.where(action: 'rate', checked: false).update_all(checked: true)
  end
end
