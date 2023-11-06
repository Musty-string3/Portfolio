class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, except: %i[index]

  def index
    user_id = params[:user_id]
    @keyword = params[:keyword]
    @search_path = admin_posts_path
    @user_post = false
    if @keyword.present? && @keyword != ""
      @posts = Post.search_for(@keyword)
    elsif user_id.present?
      @posts = Post.for_user_created_desc(user_id)
      @user_post = true
    else
      @posts = Post.for_users_created_desc
    end
  end

  def show
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "投稿を削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :image)
  end
end
