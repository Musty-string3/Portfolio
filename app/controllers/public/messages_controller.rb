class Public::MessagesController < ApplicationController

  def create
    if params[:message][:text].present?
      Message.create(
        params.require(:message).permit(:user_id, :room_id, :text).merge(user_id: current_user.id)
      )
    end
    redirect_back(fallback_location: root_path)
  end

end
