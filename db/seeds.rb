# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin.create!(
#   email: "admin@01",
#   password: "111111"

# )

# # ユーザー　OK
# 5.times do |n|
#   User.create(
#     email: "#{SecureRandom.urlsafe_base64(10)}@gmail.com",
#     password: SecureRandom.urlsafe_base64(10),
#     name: "デフォルトユーザー(No.#{n + 1})",
#     introduction: "デフォルトユーザー(No.#{n + 1})です!",
#     last_name: "デフォルト",
#     first_name: "ユーザー"
#   )
# end

# # 投稿(3種類) Ok
# 3.times do |n|
#   if n + 1 == 1
#     post = Post.new(
#       post_name: "清水寺",
#       explanation: "清水寺に行ったときの写真です！",
#       user: User.find(n + 1),
#     )
#     3.times do |m|
#       file_path = Rails.root.join("app/assets/images/default_images/kiyomizudera_image#{m + 1}.jpg")
#       post.images.attach(io: File.open(file_path), filename: "kiyomizudera_image#{m + 1}.jpg", content_type: 'image/jpeg')
#     post.save!
#     end
#   elsif n + 1 == 2
#     post = Post.new(
#       post_name: "札幌市時計台",
#       explanation: "北海道の札幌市に旅行へ行ったときに訪れた札幌市時計台！",
#       user: User.find(n + 1),
#     )
#     2.times do |m|
#       file_path = Rails.root.join("app/assets/images/default_images/time#{m + 1}.jpg")
#       post.images.attach(io: File.open(file_path), filename: "time#{m + 1}.jpg", content_type: 'image/jpeg')
#     post.save!
#     end
#   else
#     post = Post.new(
#       post_name: "東尋坊綺麗すぎる！",
#       explanation: "東尋坊は本当に綺麗だった！天気も良かったし最高の１日になりました！！",
#       user: User.find(n + 1),
#     )
#     4.times do |m|
#       file_path = Rails.root.join("app/assets/images/default_images/zubotty#{m + 1}.jpg")
#       post.images.attach(io: File.open(file_path), filename: "zubotty#{m + 1}.jpg", content_type: 'image/jpeg')
#     post.save!
#     end
#   end
# end

# # タグの設定 OK
# tags_sets = [
#   ["京都", "清水寺", "観光地", "世界遺産"],
#   ["北海道", "時計台", "観光地"],
#   ["福井県", "海", "観光地", "絶景"]
# ]
# tags_sets.each do |tags|
#   tags.each do |tag_name|
#     Tag.create!(name: tag_name)
#   end
# end

# # タグの中間テーブルの設定 OK
# 11.times do |i|
#   if i + 1 < 5
#     tag = Tag.find(i + 1)
#     PostTag.create!(tag: tag, post: Post.find(1))
#   elsif i + 1 < 8
#     tag = Tag.find(i + 1)
#     PostTag.create!(tag: tag, post: Post.find(2))
#   else
#     tag = Tag.find(i + 1)
#     PostTag.create!(tag: tag, post: Post.find(3))
#   end
# end