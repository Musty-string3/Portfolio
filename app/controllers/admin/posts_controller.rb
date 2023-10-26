class Admin::PostsController < ApplicationController
  include TagCount
  before_action :authenticate_admin!
  before_action :set_post, except: %i[index]

  def index
    @posts = Post.includes(:user).all.order(created_at: :desc)
    tags = User.tag_joins_posts
    @tags = set_tag_count(tags)
  end

  def show
    @comment = nil
    @violate = nil
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
