class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  
  def index
    @posts = current_user.posts.all
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_path(@post), notice: "投稿されました！"
    else
      @post = Post.new 
      render :new
    end
  end

  def show
    @user = current_user
  end

  def edit
  end
  
  def update
    @post.update(post_params) ? (redirect_to post_path(@post)) : (render :edit)
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
