class Post < ApplicationRecord
  
  with_options presence: true do
    validates :post_name
    validates :explanation
  end
  
  has_one_attached :image
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  # ↑ tagsと多対多の関係であり、post_tagsが中間テーブルという意味　
  
  def save_tag(sent_tags)
    
    # タグが存在していれば、タグの名前を配列として全て取得 pluck=カラムの中身を展開
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    
    # ↑で取得したタグ(current_tags)から送られてきたタグ(sent_tags)を除いたタグがoldtag
    old_tags = current_tags - sent_tags
    
    # 送信されてきたタグ(sent_tags)から現在存在するタグ(current_tags)を除いたタグがnew_tags
    new_tags = sent_tags - current_tags
    
    # 古いタグ(old_tags)を消す
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end
    
    # 新しいタグ(new_tags)を保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end
  
  def self.search_for(keyword)
    Post.where('post_name LIKE ?', keyword + '%')
  end
  
  def like?(user)
    likes.where(user_id: user.id).exists?
  end
end