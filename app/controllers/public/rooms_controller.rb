class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    room = Room.create
    curent_entry = Entry.create(room_id: room.id, user_id: current_user.id)
    another_entry = Entry.create(room_id: room.id, user_id: params[:entry][:user_id])
    redirect_to room_path(room)
  end
  
  def index
    
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
