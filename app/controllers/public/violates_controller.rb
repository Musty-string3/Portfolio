class Public::ViolatesController < ApplicationController
  before_action :authenticate_user!

  def create
    violate = current_user.violates.new(violate_params)
    violate.status = params[:violate][:status].to_i

    if violate.save && is_exist_violate?
      redirect_back fallback_location: root_path
      flash[:notice] = "投稿の報告を申請しました。"
      # 管理者に違反通知がされる
      violate.create_notification_violate!(current_user)
    else
      redirect_back fallback_location: root_path
      flash[:notice] = "この投稿に対する報告は既に申請済みです。"
    end
  end

  private

  def violate_params
    params.require(:violate).permit(:reported_id, :text, :post_id)
  end
end
