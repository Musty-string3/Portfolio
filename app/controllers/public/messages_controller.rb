class Public::MessagesController < ApplicationController

  def create
    if params[:message][:text].present?
      @message = Message.create(message_params)
    end
    @messages = Message.where(room_id: @message.room.id)
  end

  private
  
  def message_params
    params.require(:message).permit(:user_id, :room_id, :text).merge(user_id: current_user.id)
  end
end
