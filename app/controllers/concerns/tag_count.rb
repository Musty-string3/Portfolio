module TagCount
  def set_tag_count(tags)
    tag_counts = Hash.new(0)
    tags.each do |tag|
      tag_counts[tag] += 1
    end
    tag_counts
  end
end