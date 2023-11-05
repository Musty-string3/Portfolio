class Post < ApplicationRecord
  include WrittenBy

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
  has_many :liked_user, through: :likes, source: :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :notifications, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many :violates, dependent: :destroy

  scope :for_users_created_desc, -> {includes(:user).all.order(created_at: :desc)}

  # タグの保存、編集
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

  def self.search_for(keyword)
    Post.where('post_name LIKE?', keyword+'%').order(created_at: :desc)
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

  # いいね通知
  def create_notification_like!(current_user, post, user)
    unless current_user == user
      Notification.find_or_create_by!(
        visitor_id: current_user.id,
        visited_id: user_id,
        post_id: post.id,
        action: 'like'
      )
    end
  end

  # コメント通知
  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.where(post_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    unless current_user == visited_id
      current_user.myself_notifications.find_or_create_by!(
        post_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
      )
    end
  end

  def has_lat_lng
    lat.present? && lng.present?
  end

  def self.for_user_created_desc(user_id)
    where(user_id: user_id).order(created_at: :desc)
  end

  def self.sort_by_like(params_index)
    posts = includes(:likes)
    if params_index == "like"
      posts.sort_by {|x| x.likes.size}.reverse
    elsif params_index == "likes_in_week"
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      posts.sort_by {|x| x.likes.where(created_at: from...to).size}.reverse
    else
      includes(:user).order(created_at: :desc)
    end
  end

  def self.where_records_for_user(user)
    includes(:user).where(user_id: user.id)
  end

  def self.liked_by_others(current_user)
    joins(:likes).where(likes: {user_id: current_user.id}).where.not(user_id: current_user.id)
  end

  def self.posts_by_followings(current_user)
    where(user_id: [*current_user.followings.ids])
  end

  def self.related_to_tag(tag)
    joins(:user, :tags).where(tags:{name: tag.name})
  end

  def self.find_by_user_post(post, current_user)
    find_by(user_id: current_user.id, id: post)
  end

end