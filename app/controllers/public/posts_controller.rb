class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.all
    @tag_list = Tag.all
  end

  def index_current
    @posts = current_user.posts.all
    @tag_list = Tag.all
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
    @user = current_user
    @post_tags = @post.tags
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
    redirect_to post_path(@post)
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :post_name, :explanation, :image)
  end


end
