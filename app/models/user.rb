class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  scope :only_active, -> { where(is_deleted: true) }
  #is_deletedがtrue(退会してない)の会員レコードを取得
         
  validates :last_name, presence: true                                #名が空白ならエラー
  validates :first_name, presence: true                               #姓が空白ならエラー
  validates :name, presence: true, uniqueness: true                   #ニックネームが空白＆他の会員とニックネームが一致した場合にエラー
  validates :encrypted_password, length: {minimum: 6}                 #パスワードが空白＆最小文字数が6文字以上でないとエラー
  validates :introduction, length: { maximum: 100 }                   #最大文字数100文字
  
  def full_name
    first_name + " " + last_name
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
    User.where('name LIKE ?', keyword+'%')
  end
  
end
