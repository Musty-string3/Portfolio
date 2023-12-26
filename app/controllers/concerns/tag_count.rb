# 今後、特定のタグが何回使われているかを見たいときに使用する
# 例：観光地(3件)

module TagCount
  def set_tag_count(tags)
    tag_counts = Hash.new(0)
    tags.each do |tag|
      tag_counts[tag] += 1
    end
    tag_counts
  end
end