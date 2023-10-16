class Public::RelationsController < ApplicationController
  before_action :is_room

  def followings # フォロー一覧
    @users = User.find(params[:user_id]).followings
  end

  def followers # フォロワー一覧
    @users = User.find(params[:user_id]).followers
  end

  def create #フォローする
    current_user.relations.find_or_create_by(followed_id: params[:user_id])
    @user.create_notification_follow!(current_user)
  end

  def destroy #フォロー外す
    current_user.relations.find_by(followed_id: params[:user_id]).destroy
  end

  private

  def is_room
    @user = User.find(params[:user_id])
    current_user_entry = Entry.where(user_id: current_user.id)
    user_entry = Entry.where(user_id: @user.id)
    @isRoom = false
    unless @user == current_user
      current_user_entry.each do |current|
        user_entry.each do |user|
          if current.room_id == user.room_id
            @isRoom = true
            @room_id = current.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end
end
