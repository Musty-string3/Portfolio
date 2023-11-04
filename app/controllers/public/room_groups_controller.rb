class Public::RoomGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room_groups, only: %i[show edit update destroy]
  before_action :room_group_join, except: %i[index new create]
  # ↑ ユーザーが加入していない別のグループに入ってこないための処理

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
      redirect_to room_group_path(@group.id)
      flash[:notice] = "グループチャットを作成しました！"
    else
      render :new
    end
  end

  def show
    @leader = UserGroup.find_by(room_group_id: @group.id, is_leader: true)
    @group_users = UserGroup.includes(:user).where(room_group_id: @group.id)
    @current_user_group = UserGroup.user_group_join?(current_user, @group)
    # message_groupsの作成
    @message_group = MessageGroup.new
    @message_groups = MessageGroup.includes(:user).where(room_group_id: @group)
    # 退会機能
    @room_group = RoomGroup.find(params[:id])
    @group_leader = UserGroup.find_by(
      user_id: current_user.id,
      room_group_id: @room_group,
      is_leader: true
    )
    if @group_leader
      @is_leader = true
      @current_user_group = UserGroup.user_group_join?(current_user, @room_group)
    else
      @current_user_group = UserGroup.user_group_join?(current_user, @room_group)
    end
  end

  def edit
  end

  def update
    if @group.update(room_group_params)
      redirect_to room_group_path(@group.id)
      flash[:notice] = "グループチャットを更新しました！"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to room_groups_path
    flash[:alert] = "グループチャットを削除しました。"
  end

  private

  def set_room_groups
    @group = RoomGroup.find(params[:id])
  end

  def room_group_join
    group = UserGroup.find_by(user_id: current_user.id, room_group_id: params[:id])
    unless group.present?
      redirect_back fallback_location: room_groups_path
    end
  end

  def room_group_params
    params.require(:room_group).permit(:name, :group_description, :count)
  end

end
