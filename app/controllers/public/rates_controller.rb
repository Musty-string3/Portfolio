class Public::RatesController < ApplicationController
  before_action :authenticate_user!

  def new
    @rate = Rate.new
    # ログインユーザーのレビューは存在する？
    @is_rate = Rate.find_by(user_id: current_user.id)
  end

  def create
    unless Rate.find_by(user_id: current_user.id)
      rate = Rate.create(rate_params)
      rate.create_notification_rate!(current_user)
      flash[:danger] = rate.errors.full_messages unless rate.save
      redirect_to new_rate_path
    end
  end

  # TODO
  private

  def rate_params
    params.require(:rate).permit(:star, :text).merge(user_id: current_user.id)
  end

end
