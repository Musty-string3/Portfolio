class Public::PostsController < ApplicationController

  include TagCount  # app/controllers/concerns/tag_count.rbが使える
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy]
  before_action :current_user?, only: %i[edit update destroy]

  def index
    sort = params[:sort]
    @posts = Post.sort_by_like(sort)
    @sort_condition = sort_condition(sort)
    tags = User.tag_joins_posts
    @tags = set_tag_count(tags)
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
      redirect_to post_path(@post), notice: "投稿されました！"
    else
      render :new
      @tag_list = Tag.new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @violate = Violate.new
    unless @post.user == current_user
      ViewCount.find_or_create_by(user_id: current_user.id, post_id: @post.id)
    end
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join('　')
  end

  def update
    tag_list = params[:post][:tag].split('　')
    if @post.update(post_params)
      @post.save_tag(tag_list, @post)
      redirect_to post_path(@post), notice: "投稿の編集に成功しました。"
    else
      render :edit, notice: "投稿の編集に失敗しました。"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def sort_condition(text)
    if text == "like"
      "いいね順"
    elsif text == "likes_in_week"
      "直近1週間のいいね順"
    else
      "新着投稿順"
    end
  end


  def set_post
    @post = Post.find(params[:id])
  end

  def current_user?
    post = Post.find_by(user_id: current_user.id, id: @post.id)
    unless post
      redirect_back fallback_location: user_path(current_user.id)
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :lat, :lng, images: [])
  end


end
