class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    post_comments = params[:post_comments]
    @keyword = params[:keyword]
    if @keyword.present? && @keyword != ""
      @model = params[:model]
      @comments = Comment.search_by_keyword_and_model(@keyword, @model)
    else
      @comments = Comment.load_for_posts(post_comments)
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to admin_comments_path, notice: 'コメントを削除しました'
  end

end
