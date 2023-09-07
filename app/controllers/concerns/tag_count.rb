module TagCount
  def set_tag_count(posts)
    tag_counts = Hash.new(0)
    posts.each do |post|
      post.tags.each do |tag|
        tag_counts[tag.name] += 1
      end
    end
    tag_counts
  end
end