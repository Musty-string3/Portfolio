class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  # コメントに対するいいね
  has_many :comment_likes, dependent: :destroy
  
  validates :text, presence: true
  
  def comment_like(comment, user)
    comment_likes.where(comment_id: comment.id, user_id: user.id).empty?
    # empty?とはexists?の逆の意味で、0件ならtureを返し、1件以上ならfalseを返す
  end
end
