class Public::UserGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_group_is_leader, only: %i[update]
  before_action :set_user_group, only: %i[update destroy withdrawal]
  before_action :set_room_group, only: %i[index destroy withdrawal]

  def create
    room_group = RoomGroup.includes(:user_groups).find(params[:group_id])
    unless UserGroup.find_by(user_id: current_user.id, room_group_id: params[:group_id])
      if room_group.count > room_group.user_groups.count
        UserGroup.create(
        user_id: current_user.id, room_group_id: params[:group_id])
        redirect_to room_group_path(params[:group_id]), notice: "グループチャットに参加しました。"
      else
        redirect_back fallback_location: root_path, notice: "グループチャットに参加できませんでした。"
      end
    end
  end

  def index
    @user_groups = UserGroup.includes(:user).where(room_group_id: params[:room_group_id])
    @user_group = UserGroup.find_by(user_id: current_user.id, room_group_id: params[:room_group_id], is_leader: true)
  end

  def update

  end

  def destroy
    # 退会のURLをbefore_actionで制限しないとハッキングされる？
    if @user_group.is_leader == false && params[:removed?]
      # @user_group.destroy
      redirect_to room_group_path(@group), notice: "#{@user_group.user.name}さんを強制退会させました。"
    elsif @user_group.is_leader
      # @user_group.room_group.destroy
      redirect_to room_groups_path, notice: "グループチャットを削除しました。"
    else
      # @user_group.destroy
      redirect_to room_groups_path, notice: "グループチャットを退会しました。"
    end
  end

  def withdrawal
    if @user_group.is_leader
      @leader = true
      @current_user_group = UserGroup.user_group_join?(current_user, @group)
    elsif @ejected = params[:removed?]
      @with_member = UserGroup.user_group_join?(@user_group.user, @group)
    else
      @current_user_group = UserGroup.user_group_join?(current_user, @group)
    end
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def set_room_group
    @group = RoomGroup.find(params[:room_group_id])
  end

  def user_group_is_leader
    user_group = UserGroup.find_by(
    user_id: current_user.id, room_group_id: params[:room_group_id], is_leader: true)
    unless user_group.present?
      redirect_back fallback_location: room_group_path(params[:room_group_id])
    end
  end
end
