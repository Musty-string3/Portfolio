class Public::ViolatesController < ApplicationController
  before_action :authenticate_user!

  def create
    is_exist_violate = Violate.find_by(
      reporter_id: current_user.id,
      reported_id: params[:violate][:reported_id],
      post_id: params[:violate][:post_id],
      status: params[:violate][:status]
    )
    if is_exist_violate.nil?
      violate = current_user.reporter_violates.create!(violate_params)
      redirect_back fallback_location: root_path
      flash[:notice] = "投稿の報告を申請しました。"
      violate.create_notification_violate!(current_user)  # 管理者に違反通知がされる
    else
      redirect_back fallback_location: root_path
      flash[:alert] = "この投稿に対する報告は既に申請済みです。"
    end
  end

  private

  def violate_params
    params.require(:violate).permit(:reported_id, :text, :post_id, :status)
  end
end