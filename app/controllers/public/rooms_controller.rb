class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :entry_exists?, only: %i[create]
  before_action :room_join?, only: %i[show]

  def create
    room = Room.create
    Entry.create(room_id: room.id, user_id: current_user.id)
    Entry.create(room_id: room.id, user_id: params[:entry][:user_id])
    redirect_to room_path(room)
  end

  def index
    @entries = Entry.includes(:user).where(user_id: current_user.id)
    room_id = []
    @entries.each do |entry|
      room_id << entry.room_id
    end
    @another_entries = Entry.where(room_id: room_id).where.not(user_id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = Message.where(room_id: @room.id)
    @message = Message.new
    @entries = Entry.where(room_id: @room.id)
    # 下記はEnumerable = イーナマラブルを使って動作している
    @current_entry = @entries.find {|entry| entry.user_id == current_user.id}
    @another_entry = @entries.find {|entry| entry.user_id != current_user.id}
  end

  private

  def entry_exists?
    partner_user = User.find(params[:entry][:user_id])
    current_room_id = Entry.check_chatroom(partner_user, current_user)
    redirect_to room_path(current_room_id) unless current_room_id == false
  end

  def room_join?
    room = params[:id]
    chat_partner = Entry.find_by(
      user_id: Entry.where(room_id: room).where.not(user_id: current_user.id).pluck(:user_id),
      room_id: room
    )
    if chat_partner.blank?
      flash[:alert] = "指定されたDMルームは利用できません。"
      redirect_to rooms_path
    end
  end

end