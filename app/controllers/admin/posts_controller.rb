class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, except: %i[top]

  def top
    @posts = Post.includes(:user).all
    @tags = Tag.all
  end

  def show
    @posts = Post.where(id: @post)
    @tags = PostTag.where(post_id: @post)
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
    redirect_to admin_root_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :image)
  end
end
