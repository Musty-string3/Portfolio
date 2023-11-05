class Tag < ApplicationRecord

  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  #tagsとpostsの多対多の関係の設定↓
  has_many :posts, dependent: :destroy, through: :post_tags

  def self.search_for(keyword)
    Tag.where('name LIKE?', keyword+'%')
  end
  
end
