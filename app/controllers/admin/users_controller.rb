class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_users, except: %i[index]

  def index
    @keyword = params[:keyword]
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
      redirect_to admin_user_path(@user), notice: "ユーザー情報の変更に成功しました。"
    else
     render :edit, notice: "会員情報の編集に失敗しました。再度内容をご確認ください。"
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
