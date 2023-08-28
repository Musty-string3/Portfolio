class Post < ApplicationRecord
  
  with_options presence: true do
    validates :post_name
    validates :explanation
  end
  
  has_one_attached :image
  
  belongs_to :user
end
