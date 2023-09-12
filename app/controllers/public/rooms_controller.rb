class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    room = Room.create
    curent_entry = Entry.create(:room_id: room.id, :user_id: current_user.id)
    another_entry = Entry.create(:room_id: room.id, :user_id: params[:entry][:user_id])
    redirect_to room_path(room)
  end
  
  def show
    @room = Room.find(params[:id])
    @messages = Room.inculdes(:messages).where(messages: {room_id: id})
    @message = Message.new
    @entries = Room.includes(:entries).where(entries: {room_id: id})
  end
  
end
