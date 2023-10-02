class Rate < ApplicationRecord

  belongs_to :user

  with_options presence: true do
    validates :user
    validates :star
  end
end
