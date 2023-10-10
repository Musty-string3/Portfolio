class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = Comment.includes(:user, :post).order(created_at: :desc)
    @comment_count = Comment.group(:post_id).count
    # コメントテーブルのpost_idカラムごとにグループ(ハッシュ)を作成してカウントを数える
  end

  def destroy
    Commnet.find(params[:id]).destroy
    redirect_to admin_commets_path
  end

  def search
    @keyword = params[:keyword]
    @model = params[:model]
    @count = 0
    if @model == 'user'
      @users = User.search_comments(@keyword)
      @users.each do |user|
        @count += user.comments.count
      end
    else
      @posts = Post.search_comments(@keyword)
      @posts.each do |post|
        @count += post.comments.count
      end
    end
  end

end
