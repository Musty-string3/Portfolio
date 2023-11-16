class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user?, only: %i[edit update destroy]
  before_action :set_post, only: %i[edit update destroy]

  def index
    sort = params[:sort]
    @posts = Post.sort_by_like(sort)
    @sort_condition = sort_condition(sort)
  end

  def new
    @post = Post.new
    @tag_list = Tag.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_list = params[:post][:tag].split('　')
    if @post.save
      @post.save_tag(tag_list, @post)
      redirect_to post_path(@post)
      flash[:notice] = "投稿されました"
    else
      @tag_list = Tag.new
      flash[:alert] = "投稿に失敗しました"
      render :new
    end
  end

  def show
    begin
      @post = Post.find(params[:id])
    rescue  ActiveRecord::RecordNotFound
      redirect_to posts_path
      flash[:alert] = "投稿は存在しません"
      return
    end
    @comment = Comment.new
    @violate = Violate.new
    unless @post.user == current_user
      ViewCount.find_or_create_by(user_id: current_user.id, post_id: @post.id)
    end
  end

  def edit
    @post_images_url = @post.images.map{|image| url_for image}
    @tag_list = @post.tags.pluck(:name).join('　')
  end

  def update
    @post_images_url = @post.images.map{|image| url_for image}
    tag_list = params[:post][:tag].split('　')
    if @post.update(post_params)
      @post.save_tag(tag_list, @post)
      redirect_to post_path(@post)
      flash[:notice] = "投稿の編集に成功しました。"
    else
      render :edit
      flash[:alert] = "投稿の編集に失敗しました。"
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to posts_path
  end

  private

  def sort_condition(text)
    case text
    when "like"
      "いいね順"
    when "likes_in_week"
      "直近1週間のいいね順"
    else
      "新着投稿順"
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def current_user?
    post = Post.find_by(id: params[:id], user_id: current_user.id)
    if post.blank?
      flash[:alert] = "別のユーザーの投稿は操作できません。"
      redirect_to user_path(current_user.id)
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :lat, :lng, images: [])
  end

end