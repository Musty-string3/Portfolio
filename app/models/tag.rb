class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, dependent: :destroy, through: :post_tags

  def self.search_keyword_present(post_id, keyword, tag_name)
    return search_for(keyword) if keyword.present?
    return joins(:posts).where(posts: {id: post_id}) if post_id.present?
    return where(name: tag_name) if tag_name.present?
    includes(:posts).all.order(created_at: :desc)
  end

  def self.search_for(keyword)
    Tag.where('name LIKE?', keyword+'%').order(created_at: :desc)
  end

end
