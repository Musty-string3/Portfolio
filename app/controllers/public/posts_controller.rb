class Public::PostsController < ApplicationController

  include TagCount  # app/controllers/concerns/tag_count.rbが使える
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy]

  def index
    if params[:index] == "like"
      @posts = Post.includes(:likes).sort_by {|x| x.likes.size}.reverse
      @index = "いいね順"
    elsif params[:index] == "likes_in_week"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @posts = Post.includes(:likes).sort_by {|x| x.likes.where(created_at: from...to).size}.reverse
      @index = "直近1週間のいいね順"
    else
      @posts = Post.includes(:user).order(created_at: :desc)
      @index = "新着投稿順"
    end
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
      @post.save_tag(tag_list)
      redirect_to post_path(@post), notice: "投稿されました！"
    else
      @tag_list = Tag.new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @violate = Violate.new
    unless @post.user == current_user
      # ログインユーザーの投稿 == 自分自身の投稿だった場合、閲覧カウントしない
      ViewCount.find_or_create_by(user_id: current_user.id, post_id: @post.id)
    end
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join('、')
  end

  def update
    tag_list = params[:post][:tag].split('、')
    if @post.update(post_params)
      # 投稿に紐付いているタグを全消去する
      @post.post_tags.destroy_all
      # タグを全消去したら再度タグを作成する
      @post.save_tag(tag_list)
      redirect_to post_path(@post), notice: "投稿の編集に成功しました。"
    else
      render :edit, notice: "投稿の編集に失敗しました。"
    end
    # @customer.update(customer_params) ? (redirect_to admin_customer_path(@customer)) : (render :edit)
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  # いいねした投稿
  def likes
    @posts = Post.includes(:likes).where(likes: {user_id: current_user.id}).where.not(user_id: current_user.id)
  end

  def timeline
    # フォローしているユーザーの全ての投稿を取得する
    @posts = Post.where(user_id: [*current_user.followings.ids])
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :lat, :lng, images: [])
  end


end
