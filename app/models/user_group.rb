class UserGroup < ApplicationRecord
  include WrittenBy

  belongs_to :user
  belongs_to :room_group

  delegate :get_profile_image, to: :user

  def role_name
    if is_leader
      "#{user.name}(リーダー)"
    else
      user.name
    end
  end

  def self.user_group_join(user, group)
    find_by(user_id: user.id, room_group_id: group.id)
  end

end