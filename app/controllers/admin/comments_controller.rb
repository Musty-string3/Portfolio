class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    post_comments = params[:post_comments]
    @keyword = params[:keyword]
    @model = params[:model]
    @comments = Comment.search_keyword_present(post_comments, @keyword, @model).page(params[:page]).per(10)
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to admin_comments_path, notice: 'コメントを削除しました'
  end

end
