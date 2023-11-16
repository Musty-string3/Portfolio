class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, except: %i[index]

  def index
    @keyword = params[:keyword]
    @user_id = params[:user_id]
    @posts = Post.search_keyword_present(@keyword, @user_id)
    @search_path = admin_posts_path
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
