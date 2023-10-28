class Admin::PostsController < ApplicationController
  include TagCount
  before_action :authenticate_admin!
  before_action :set_post, except: %i[index]

  def index
    user_id = params[:user_id]
    if user_id
      @posts = Post.for_user_created_desc(user_id)
    else
      @posts = Post.for_users_created_desc
      tags = User.tag_joins_posts
      @tags = set_tag_count(tags)
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
