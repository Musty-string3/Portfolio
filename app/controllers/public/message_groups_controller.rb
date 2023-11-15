class Public::MessageGroupsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    MessageGroup.create(messages_params)
    redirect_to room_group_path(params[:room_group_id])
  end
  
  private
  
  def messages_params
    params.require(:message_group).permit(:room_group_id, :text).merge(user_id: current_user.id)
  end
end
