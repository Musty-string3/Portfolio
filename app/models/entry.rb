class Entry < ApplicationRecord

  belongs_to :user
  belongs_to :room

  def self.count_by_user(user)
    where(user_id: user.id).count
  end

  def self.check_chatroom(user, current_user)
    room = Entry.find_by(
      user_id: current_user.id,
      room_id: Entry.where(user_id: user.id).pluck(:room_id)
    )
    return room.present? ? room.room_id : false
  end

  def self.find_matching_entry(room, current_user)
    find_by(
      user_id: Entry.where(room_id: room).where.not(user_id: current_user.id).pluck(:user_id),
      room_id: room
    )
  end
end
