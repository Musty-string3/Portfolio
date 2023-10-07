class Public::ViolatesController < ApplicationController
  before_action :authenticate_user!

  def create
    violate = Violate.new(violate_params)
    violate.reporter_id = current_user.id
    violate.status = params[:violate][:status].to_i
    if violate.save
      redirect_back fallback_location: root_path
      flash[:notice] = "投稿の報告を申請しました。"
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def violate_params
    params.require(:violate).permit(:reported_id, :text, :post_id)
  end
end
