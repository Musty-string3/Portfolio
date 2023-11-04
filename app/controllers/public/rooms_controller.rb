class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
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
    @current_entry = @entries.find {|entry| entry.user_id == current_user.id}
    @another_entry = @entries.find {|entry| entry.user_id != current_user.id}
  end

end
