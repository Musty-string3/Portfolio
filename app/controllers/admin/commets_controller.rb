class Admin::CommetsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @comments = Comment.includes(:user, :post).order(created_at: :desc)
    @comment_count = Comment.group(:post_id).count
    @comment_count = Comment.group(:post_id)
    # コメントテーブルのpost_idカラムごとにグループ(ハッシュ)を作成してカウントを数える
  end
  
  def destroy
    Commnet.find(params[:id]).destroy
    redirect_to admin_commets_path
  end
end
