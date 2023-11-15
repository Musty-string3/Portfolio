class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_users, except: %i[index]

  def index
    @keyword = params[:keyword]
    @users = User.search_keyword_present(@keyword)
    @search_path = admin_root_path
  end

  def show
    @user_posts = Post.where(user_id: @user.id)
  end

  def edit
    @image_url = url_for @user.profile_image
  end

  def update
    @image_url = url_for @user.profile_image
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
