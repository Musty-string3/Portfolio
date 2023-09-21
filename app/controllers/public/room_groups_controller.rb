class Public::RoomGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room_groups, only: %i[show edit update destroy]

  def index
    @groups = RoomGroup.includes(:user_groups).all
  end

  def new
    @group = RoomGroup.new
  end

  def create
    @group = RoomGroup.new(room_group_params)
    if @group.save
      current_user.user_groups.create(
        room_group_id: @group.id,
        is_leader: true
      )
      redirect_to room_group_path(@group.id), notice: "グループチャットを作成しました！"
    else
      render :new
    end
  end

  def show
    @leader = UserGroup.find_by(room_group_id: @group.id, is_leader: true)
    @group_users = UserGroup.includes(:user).where(room_group_id: @group.id)
    # byebug
  end

  def edit
  end

  def update
    if @group.update(room_group_params)
      redirect_to room_group_path(@group.id), notice: "グループチャットを作成しました！"
    else
      render :edit
    end
  end

  def destroy

  end

  private
  
  def set_room_groups
    @group = RoomGroup.find(params[:id])
  end

  def room_group_params
    params.require(:room_group).permit(:name, :group_description)
  end
end
