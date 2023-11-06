class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_users, except: %i[index]

  def index
    @keyword = params[:keyword]
    @search_path = admin_root_path
    if @keyword.present? && @keyword != ""
      @users = User.search_for(@keyword)
    else
      @users = User.all.order(created_at: :desc)
    end
  end

  def show
    @user_posts = Post.where(user_id: @user.id)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
      flash[:notice] = "ユーザー情報を変更しました。"
    else
     render :edit
    end
  end

  private

  def set_users
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :email, :is_deleted, :profile_image)
  end
end
