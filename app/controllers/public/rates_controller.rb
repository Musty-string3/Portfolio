class Public::RatesController < ApplicationController
  before_action :authenticate_user!

  def new
    @rate = Rate.new
    @is_rate = Rate.find_by(user_id: current_user.id)
  end

  def create
    if Rate.find_by(user_id: current_user.id).nil?
      rate = Rate.new(rate_params)
      if rate.save
        rate.create_notification_rate!(current_user)
        redirect_back fallback_location: root_path
      else
        flash[:alert] = "もう一度入力をお願いします。"
        redirect_back fallback_location: root_path
      end
    end
  end

  # TODO
  private

  def rate_params
    params.require(:rate).permit(:star, :text).merge(user_id: current_user.id)
  end

end
