class Public::PostsController < ApplicationController
  
  include TagCount  # app/controllers/concerns/tag_count.rbが使える
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user)
    tags = Tag.joins(:posts).select(:id, :name)
    @tags = set_tag_count(tags)
    # User.find(1).includes(:posts) ユーザー1の全投稿取得
  end

  def new
    @post = Post.new
    @tag_list = Tag.new
  end

  def create
    post = current_user.posts.new(post_params)
    # 受け取った値を,で区切って配列にする。split=分割して配列を作る
    tag_list = params[:post][:tag].split('、')
    if post.save
      # postモデルで定義したsave_tagでタグを保存
      post.save_tag(tag_list)
      redirect_to post_path(post), notice: "投稿されました！"
    else
      @post = Post.new
      render :new
    end
  end

  def show
    @post = Post.includes(:user).find(params[:id])
    @post_tags = Post.includes(:tags).find(params[:id])
    @comment = Comment.new
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


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :image)
  end


end
