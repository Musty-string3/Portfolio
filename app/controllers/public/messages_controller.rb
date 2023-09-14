class Public::MessagesController < ApplicationController

  def create
    #@room = Room.find(params[:id])
    
    if params[:message][:text].present?
      @message = Message.create(
        params.require(:message).permit(:user_id, :room_id, :text).merge(user_id: current_user.id)
      )
    end
    @messages = Message.where(room_id: @message.room.id)
  end

end
