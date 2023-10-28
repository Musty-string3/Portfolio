class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  # コメントに対するいいね
  has_many :comment_likes, dependent: :destroy

  validates :text, presence: true

  scope :all_created_desc, -> {includes(:user, :post).all.order(created_at: :desc)}

  def comment_like(comment, user)
    comment_likes.where(comment_id: comment.id, user_id: user.id).empty?
    # empty?とはexists?の逆の意味で、0件ならtureを返し、1件以上ならfalseを返す
  end

  def self.search_by_keyword_and_model(keyword, model)
    comments = []
    if model == 'user'
      users = User.search_for(keyword)
      users.each do |user|
        user.comments.each do |comment|
          comments << comment
        end
      end
    else
      posts = Post.search_for(keyword)
      posts.each do |post|
        post.comments.each do |comment|
          comments << comment
        end
      end
    end
    comments
  end
  
  def self.load_for_posts(post_comments)
    if post_comments
      Comment.where(post_id: post_comments)
    else
      Comment.all_created_desc
    end
  end
end
