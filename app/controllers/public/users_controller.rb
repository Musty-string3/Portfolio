class Public::UsersController < ApplicationController

  include TagCount
  before_action :authenticate_user!
  before_action :set_current_user, except: %i[show]
  before_action :current_user?, only: %i[edit_information update withdrawal likes timeline]
  before_action :guest_user, only: %i[edit_information update withdrawal]

  def show
    @user = User.find(params[:id])
    @user_posts = Post.where_records_for_user(@user)
    @entries_count = Entry.count_by_user(@user)
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
    @image_url = url_for @user.profile_image
  end

  def update
    @image_url = url_for @user.profile_image
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を変更しました"
      redirect_to user_path(@user)
    else
      flash[:alert] = "会員情報の編集に失敗しました。再度内容をご確認ください。"
      render :edit_information
    end
  end

  def withdrawal
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
    flash[:notice] ="退会処理を実行しました"
  end

  def likes
    @posts = Post.liked_by_others(current_user)
  end

  def timeline
    @posts = Post.posts_by_followings(current_user)
  end

  private

  def set_current_user
    @user = current_user
  end

  def current_user?
    user = params[:id].to_i
    unless user == current_user.id
      flash[:alert] = "他のユーザーの情報は操作できません"
      redirect_back fallback_location: user_path(current_user.id)
    end
  end

  def guest_user
    if @user.email == 'guest@sample.com'
      redirect_back fallback_location: root_path
      flash[:alert] = "ゲストユーザーのプロフィール編集はできません。"
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :profile_image)
  end
end