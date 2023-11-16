class Public::UsersController < ApplicationController

  include TagCount
  before_action :authenticate_user!
  before_action :current_user?, only: %i[edit_information update withdrawal likes timeline]
  before_action :guest_user, only: %i[edit_information update withdrawal]

  def show
    @user = User.find(params[:id])
    @user_posts = Post.includes(:user).where(user_id: @user.id)
    @entries_count = Entry.where(user_id: @user.id).count
    @room_id = Entry.check_chatroom(@user, current_user)
    @isRoom = false
    if @room_id
      @isRoom = true
    else
      @room = Room.new
      @entry = Entry.new
    end
  end


  def edit_information
    @user = current_user
    @image_url = url_for current_user.profile_image
  end

  def update
    @user = current_user
    @image_url = url_for current_user.profile_image
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を変更しました"
      redirect_to user_path(current_user)
    else
      flash[:alert] = "会員情報の編集に失敗しました。再度内容をご確認ください。"
      render :edit_information
    end
  end

  def withdrawal
    current_user.update(is_deleted: true)
    reset_session
    redirect_to root_path
    flash[:notice] ="退会処理を実行しました"
  end

  def likes
    @posts = current_user.liked_posts
  end

  def timeline
    @posts = Post.where(user_id: current_user.followings_posts)
  end

  private

  def current_user?
    user = params[:id].to_i
    unless user == current_user.id
      flash[:alert] = "他のユーザーの情報は操作できません"
      redirect_back fallback_location: user_path(current_user.id)
    end
  end

  def guest_user
    if current_user.email == 'guest@sample.com'
      redirect_back fallback_location: root_path
      flash[:alert] = "ゲストユーザーのプロフィール編集はできません。"
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :profile_image)
  end
end