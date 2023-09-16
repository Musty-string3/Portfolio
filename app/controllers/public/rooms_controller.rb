class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Roomテーブルを作成すると同時にEntryテーブルも作成する(理由↓)
    # 下記のRoom.createで作成したRoomテーブルのidを取得してEntryテーブルに使うため
    room = Room.create
    # ログインユーザーのEntryテーブルを作成
    Entry.create(room_id: room.id, user_id: current_user.id)
    # ログインユーザーと同じroom_idのEntryテーブルを作成(他ユーザー)
    Entry.create(room_id: room.id, user_id: params[:entry][:user_id])
    redirect_to room_path(room)
  end
  
  def index
    @entries = Entry.includes(:user).where(user_id: current_user.id)
    room_id = []
    @entries.each do |entry|
      room_id << entry.room_id
    end
    @another_entries = Entry.where(room_id: room_id).where.not(user_id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = Message.where(room_id: @room.id)
    @message = Message.new
    @entries = Entry.where(room_id: @room.id)
    @entries.each do |entry|
      if entry.user_id == current_user.id
        @current_entry = entry
      else
        @another_entry = entry
      end
    end
  end

end
