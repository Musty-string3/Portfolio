class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, dependent: :destroy, through: :post_tags

  # return Post[]
  # description
  # args post_id 特定の投稿に紐付いたタグの表示
  # args keyword 検索したタグの表示
  # args tag_name 同じ名前のタグを全て表示
  def self.search_keyword_present(post_id, keyword, tag_name)
    return joins(:posts).where(posts: {id: post_id}) if post_id.present? && keyword.blank? && tag_name.blank?
    return search_for(keyword) if keyword.present?
    return where(name: tag_name) if tag_name.present?
    includes(:posts).all.order(created_at: :desc)
  end

  def self.search_for(keyword)
    Tag.where('name LIKE?', keyword+'%').order(created_at: :desc)
  end
  
  def method_name
    
  end

end
