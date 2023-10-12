class Admin::PostsController < ApplicationController
  include TagCount
  before_action :authenticate_admin!
  before_action :set_post, except: %i[index]

  def index
    user_id = params[:user_index]
    if user_id
      @posts = Post.where(user_id: user_id).order(created_at: :desc)
      @user = User.find(user_id)
    else
      @posts = Post.includes(:user).all.order(created_at: :desc)
      tags = User.tag_joins_posts
      @tags = set_tag_count(tags)
    end
  end

  def show
  end

  def edit
    @tags = @post.tags.pluck(:name).join('、')
  end

  def update
    tag_list = params[:post][:tag].split('、')
    if @post.update(post_params)
      @post.post_tags.destroy_all
      @post.save_tag(tag_list)
      redirect_to admin_post_path(@post), notice: "投稿の編集に成功しました。"
    else
      render :edit, notice: "投稿の編集に失敗しました。"
    end
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
