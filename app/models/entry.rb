class Entry < ApplicationRecord

  belongs_to :user
  belongs_to :room

  def self.count_by_user(user)
    where(user_id: user.id).count
  end

  def self.check_chatroom(user, current_user)
    current_user_entry = Entry.where(user_id: current_user.id)
    user_entry = Entry.where(user_id: user.id)
    unless user == current_user
      current_user_entry.each do |current|
        user_entry.each do |user|
          if current.room_id == user.room_id
            return current.room_id
          end
        end
      end
    end
    return false
  end
end
