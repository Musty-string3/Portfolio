class Public::UsersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_current_user, except: %i[show]
  
  def show
    @user = User.find(params[:id])
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "会員情報の編集に成功しました。"
    else
      render :edit, notice: "会員情報の編集に失敗しました。再度内容をご確認ください。"
    end
  end

  def unsubscribe
  end
  
  def withdrawal
    @user.update(is_deleted: true)  #is_deletedをtrueに変更する
    reset_session                   #セッション情報を全て削除
    redirect_to root_path, notice: "退会処理を実行いたしました"
  end
  
  def likes
    @posts = Post.includes(:likes).where(likes: {user_id: current_user.id})
    #Postに紐付いたlikesテーブルの中で自身がいいねした投稿を取り出す
    #where(likes: {user_id: current_user.id})でlikesテーブルのuser_idはcurrent_userと指定する
  end
  
  private
  
  def set_current_user
    @user = current_user
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :profile_image)
  end
end
