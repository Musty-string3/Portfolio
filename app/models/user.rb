class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  # コメントに対するいいね
  has_many :comment_likes, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  # グループチャットのアソシエーション
  has_many :user_groups, dependent: :destroy
  has_many :room_groups, dependent: :destroy
  has_many :message_groups, dependent: :destroy

  # DM機能
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  #フォローした、されたの関係
  has_many :relations, class_name: "Relation", foreign_key: "follow_id", dependent: :destroy
  has_many :reverse_relations, class_name: "Relation", foreign_key: "followed_id", dependent: :destroy
  #class_name: "Relation"でRelationクラスの参照、foreign_key: カラム名で保存するカラムの指定

  #フォロー一覧
  has_many :followings, through: :relations, source: :followed #フォロー中のユーザー一覧
  has_many :followers, through: :reverse_relations, source: :follow  #フォロワーのユーザー一覧
  #through: :名前 でその中間テーブルを通る、source: :名前  で参照するカラムを指定する
  #User.find(1).followingsでフォローしてくれたユーザーの一覧

  # 通知機能のアソシエーション
  has_many :myself_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :other_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # サイトのレビューのアソシエーション
  has_many :rates, dependent: :destroy

  # ルール違反者を報告するアソシエーション
  has_many :reporter_violates, class_name: 'Violate', foreign_key: 'reporter_id', dependent: :destroy
  has_many :reported_violates, class_name: 'Violate', foreign_key: 'reported_id', dependent: :destroy

  # 管理者通知のアソシエーション
  has_many :admin_notifications, foreign_key: 'visitor_id', dependent: :destroy

  #is_deletedがtrue(退会してない)の会員レコードを取得
  scope :only_active, -> { where(is_deleted: true) }

  # 投稿に紐付いたタグテーブルのidカラムとnameカラムをjoins(内部結合)にて新テーブルを作成
  scope :tag_joins_posts, -> { Tag.joins(:posts).select(:id, :name) }

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 100 }
  validates :encrypted_password, length: {minimum: 6}

  def full_name
    "#{first_name} #{last_name}"
  end

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/profile_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.search_for(keyword)
    User.where('name LIKE?', keyword+'%')
  end

  def follow?(user)
    followings.include?(user)
  end

  def written_by?(current_user, user)
    user == current_user
  end

  def create_notification_follow!(current_user)
    # 連続でフォローボタンを押すことに備えて、同じ通知レコードが存在しないときだけレコードを作成する
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user, id, 'follow'])
    if temp.blank?
      notification = current_user.myself_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      # バリエーションエラーではなかった場合にnotificationをセーブする
      notification.save if notification.valid?
    end
  end

  # 通知機能のチェックしていない通知のカウント
  def unchecked_notifications
    other_notifications.where(checked: false).count
  end

  # ゲストログイン
  def self.guest
    find_or_create_by(email: 'guest@sample.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.first_name = "ゲスト"
      user.last_name = "ユーザー"
      user.name = "ゲストユーザー"
      user.introduction = "こちらはゲストユーザーです。"
    end
  end

end
