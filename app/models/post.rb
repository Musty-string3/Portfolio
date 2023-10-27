class Post < ApplicationRecord

  validates :post_name, presence: true, length: { maximum: 20 }
  validates :explanation, presence: true, length: {  maximum: 100 }
  validates :images, presence: true

  validate :validates_images_count

  def validates_images_count
    if images.attached? && images.length > 7
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

  scope :user_post_created_desc, -> {includes(:user).all.order(created_at: :desc)}

  # タグの保存、編集
  def save_tag(sent_tags, post)
    post.post_tags.destroy_all
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

  # 検索機能
  def self.search_for(keyword)
    Post.where('post_name LIKE?', keyword+'%')
  end

  # 検索機能(管理者側)
  def self.search_comments(keyword)
    Post.includes(:user).where('post_name LIKE?', keyword+'%')
  end

  # like?(user)メソッドはlikesテーブルに引数で渡されたuser(current_user)が存在(exists)するか調べる
  # whereはlikesテーブル内にuser.id(current_user)が存在するか全部確認して存在していたらtrueを返し、逆ならfalseを返す
  def like?(user)
    likes.where(user_id: user.id).exists?
  end

  # 1週間のいいね数
  def likes_in_week
    likes.where(created_at: (Time.current.at_end_of_day - 6.day).at_beginning_of_day...Time.current.at_end_of_day).size
  end

  # 本日の投稿閲覧回数
  def today_view_count(post)
    view_counts.where(created_at: Time.zone.now.all_day, post_id: post).count
  end

  # いいね通知
  def create_notification_like!(current_user)
    # 連続でいいねをすることに備えて、同じ通知レコードが存在しないときだけレコードを作成する
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank? # tempの値がnilだったら(present?の逆)
      notification = current_user.myself_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自身の投稿にいいねした場合はcheckedカラムをtrueにして通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      # バリエーションエラーではなかった場合にnotificationをセーブする
      notification.save if notification.valid?
    end
  end

  # コメント通知
  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は投稿者に通知を送る
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification  = current_user.myself_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自身の投稿にコメントした場合はcheckedカラムをtrueにして通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end


  def written_by?(current_user)
    user == current_user
  end

  def has_lat_lng
    lat.present? && lng.present?
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


end