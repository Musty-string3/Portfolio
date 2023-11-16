class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  has_many :comment_likes, dependent: :destroy

  validates :text, presence: true

  scope :all_created_desc, -> {includes(:user, :post).all.order(created_at: :desc)}

  def comment_like(comment, current_user)
    comment_likes.where(comment_id: comment.id, user_id: current_user.id).empty?
  end

  def self.search_keyword_present(post_comments, keyword, model)
    return search_by_keyword_and_model(keyword, model) if keyword.present?
    load_for_posts(post_comments)
  end

  def self.search_by_keyword_and_model(keyword, model)
    if model == 'user'
      users = User.search_for(keyword)
      Comment.joins(:user).where(user_id: users.ids).order(created_at: :desc)
    else
      posts = Post.search_for(keyword)
      Comment.joins(:post).where(post_id: posts.ids).order(created_at: :desc)
    end
  end

  def self.load_for_posts(post_comments)
    if post_comments
      Comment.where(post_id: post_comments)
    else
      Comment.all_created_desc
    end
  end
end
