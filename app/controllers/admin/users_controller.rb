class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_users, except: %i[index]
  
  def index
    @users = User.all
  end

  def show
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー情報の変更に成功しました。"
    else
     render :show, notice: "会員情報の編集に失敗しました。再度内容をご確認ください。"
    end
  end
  
  private
  
  def set_users
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :email, :is_deleted)
  end
end
