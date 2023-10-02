class Public::RatesController < ApplicationController
  before_action :authenticate_user!

  def new
    @rate = Rate.new
    # ログインユーザーのレビューは存在する？
    @is_rate = Rate.find_by(user_id: current_user.id)
  end

  def create
    Rate.find_or_create_by(user_id: current_user.id) do |rate|
      rate.star = params[:rate][:star]
      rate.text = params[:rate][:text]
    end
    redirect_to new_rate_path
  end

  # TODO
  # private

  # def rate_params
  #   params.require(:rate).permit(:star, :text)
  # end

end
