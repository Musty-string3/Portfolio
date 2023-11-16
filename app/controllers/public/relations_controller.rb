class Public::RelationsController < ApplicationController
  before_action :is_room, only: %i[create destroy]

  def followings
    @users = User.find(params[:user_id]).followings
  end

  def followers
    @users = User.find(params[:user_id]).followers
  end

  def create
    current_user.relations.find_or_create_by(followed_id: params[:user_id])
    @user.create_notification_follow!(current_user)
  end

  def destroy
    current_user.relations.find_by(followed_id: params[:user_id]).destroy
  end

  private

  # フォローした時に非同期でDMボタンを表示させる
  def is_room
    @user = User.find(params[:user_id])
    @room_id = Entry.check_chatroom(@user, current_user)
    @isRoom = false
    if @room_id
      @isRoom = true
    else
      @room = Room.new
      @entry = Entry.new
    end
  end
end