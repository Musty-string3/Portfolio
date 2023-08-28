class Public::UsersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_current_user
  
  def show
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to users_show_path, notice: "会員情報の編集に成功しました。"
    else
      render edit, notice: "会員情報の編集に失敗しました。再度内容をご確認ください。"
    end
  end

  def unsubscribe
  end
  
  def withdrawal
    @user.update(is_deleted: true)  #is_deletedをtrueに変更する
    reset_session                   #セッション情報を全て削除
    redirect_to root_path, notice: "退会処理を実行いたしました"
  end
  
  private
  
  def set_current_user
    @user = current_user
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :profile_image)
  end
end
