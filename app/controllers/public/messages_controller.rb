class Public::MessagesController < ApplicationController

  def create
    if params[:message][:text].present?
      @message = Message.create(
        # merge()の部分はuser_idカラムをcurrent_user.idに指定している
        params.require(:message).permit(:user_id, :room_id, :text).merge(user_id: current_user.id)
      )
    end
    @messages = Message.where(room_id: @message.room.id)
  end

end
