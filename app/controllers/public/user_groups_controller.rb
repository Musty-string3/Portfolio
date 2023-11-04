class Public::UserGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_group, only: %i[update destroy]
  before_action :set_room_group, only: %i[index destroy]

  def create
    room_group = RoomGroup.includes(:user_groups).find(params[:group_id])
    unless UserGroup.find_by(user_id: current_user.id, room_group_id: params[:group_id])
      if room_group.count > room_group.user_groups.count
        UserGroup.create(
        user_id: current_user.id, room_group_id: params[:group_id])
        redirect_to room_group_path(params[:group_id])
        flash[:notice] = "グループチャットに参加しました。"
      else
        redirect_back fallback_location: root_path
        flash[:alert] = "グループチャットに参加できませんでした。"
      end
    end
  end

  def index
    @user_groups = UserGroup.includes(:user).where(room_group_id: params[:room_group_id])
    @user_group_leader = UserGroup.find_by(user_id: current_user.id, room_group_id: params[:room_group_id], is_leader: true)
    # リーダーのみが指定のユーザーを退会させる機能
    @room_group = RoomGroup.find(params[:room_group_id])
    @ejected = true
  end

  def destroy
    # 退会のURLをbefore_actionで制限しないとハッキングされる？
    if @user_group.is_leader == false && params[:removed?]
      @user_group.destroy
      redirect_to room_group_path(@group)
      flash[:alert] = "#{@user_group.user.name}さんを強制退会させました。"
    elsif @user_group.is_leader
      @user_group.room_group.destroy
      redirect_to room_groups_path
      flash[:alert] = "グループチャットを削除しました。"
    else
      @user_group.destroy
      redirect_to room_groups_path
      flash[:alert] = "グループチャットを退会しました。"
    end
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def set_room_group
    @group = RoomGroup.find(params[:room_group_id])
  end

end
