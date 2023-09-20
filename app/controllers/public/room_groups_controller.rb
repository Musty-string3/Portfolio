class Public::RoomGroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = RoomGroup.includes(:user).all
  end

  def new
    @group = RoomGroup.new
  end

  def create
    @group = RoomGroup.new(room_group_params)
    @group.user_id = current_user.id
    if @group.save
      redirect_to room_group_path(@group.id), notice: "グループチャットを作成しました！"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update

  end

  def destroy

  end

  private

  def room_group_params
    params.require(:room_group).permit(:name, :group_description)
  end
end
