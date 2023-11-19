class Post < ApplicationRecord
  include Sortable

  validates :post_name, presence: true, length: { maximum: 20 }
  validates :explanation, presence: true, length: {  maximum: 100 }
  validates :images, presence: true

  validate :validates_images_count

  def validates_images_count
    if images.attached? && images.length > 6
      errors.add(:images, 'は6枚までしか投稿できません。')
    end
  end

  has_many_attached :images

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :notifications, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many :violates, dependent: :destroy

  def written_by?(current_user)
    user == current_user
  end

  def like?(user)
    likes.where(user_id: user.id).exists?
  end

  def likes_in_week
    likes.where(created_at: (Time.current.at_end_of_day - 6.day).at_beginning_of_day...Time.current.at_end_of_day).size
  end

  def today_view_count(post)
    view_counts.where(created_at: Time.zone.now.all_day, post_id: post).count
  end

  def has_lat_lng
    lat.present? && lng.present?
  end

  def save_tag(sent_tags, post)
    post.tags.destroy_all
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  def create_notification_like!(current_user, user)
    unless current_user == user
      Notification.find_or_create_by!(
        visitor_id: current_user.id,
        visited_id: user.id,
        post_id: id,
        action: 'like'
      )
    end
  end

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.where(post_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id)
    end
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end
  def save_notification_comment(current_user, comment_id, visited_id)
    unless current_user.id == visited_id
      current_user.myself_notifications.find_or_create_by!(
        post_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
      )
    end
  end

  def self.search_keyword_present(keyword, user_id)
    return search_for(keyword) if keyword.present?
    return for_user_created_desc(user_id) if user_id.present?
    for_users_created_desc
  end

  def self.search_for(keyword)
    Post.where('post_name LIKE?', keyword+'%').order(created_at: :desc)
  end

  def self.for_user_created_desc(user_id)
    where(user_id: user_id).order(created_at: :desc)
  end

  def self.sort_by_like(params_index)
    posts = includes(:likes)
    case params_index
    when "like"
      posts.sort_by {|x| x.likes.size}.reverse
    when "likes_in_week"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      posts.sort_by {|x| x.likes.where(created_at: from...to).size}.reverse
    else
      includes(:user).order(created_at: :desc)
    end
  end
  
end