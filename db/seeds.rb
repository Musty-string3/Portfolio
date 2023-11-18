# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

# 管理者ログイン設定
Admin.create(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD']
)

puts "管理者ログイン設定完了"

# ユーザー
5.times do |n|
  User.create(
    email: "#{SecureRandom.urlsafe_base64(10)}@hoge.com",
    password: SecureRandom.urlsafe_base64(10),
    name: "デフォルトユーザー(No.#{n + 1})",
    introduction: "デフォルトユーザー(No.#{n + 1})です!",
    last_name: "デフォルト",
    first_name: "ユーザー"
  )
end

puts "エンドユーザー設定完了"

# 投稿(3種類)
post_data = [
  {
    post_name: "清水寺",
    explanation: "清水寺に行ったときの写真です！",
    lat: 34.9948561,
    lng: 135.7850463,
    images: [
      "kiyomizudera_image1.jpg",
      "kiyomizudera_image2.jpg",
      "kiyomizudera_image3.jpg"
    ]
  },
  {
    post_name: "札幌市時計台",
    explanation: "北海道の札幌市に旅行へ行ったときに訪れた札幌市時計台！",
    lat: 43.0625276,
    lng: 141.3534824,
    images: [
      "time1.jpg"
    ]
  },
  {
    post_name: "東尋坊綺麗すぎる！",
    explanation: "東尋坊は本当に綺麗だった！天気も良かったし最高の１日になりました！！",
    lat: 36.2376576,
    lng: 136.1255242,
    images: [
      "zubotty1.jpg",
      "zubotty2.jpg",
      "zubotty3.jpg",
      "zubotty4.jpg"
    ]
  }
]

post_data.each_with_index do |data, i|
  post = Post.new(
    post_name: data[:post_name],
    explanation: data[:explanation],
    user: User.find(i + 1),
    lat: data[:lat],
    lng: data[:lng]
  )
  # 画像の指定
  data[:images].each do |image|
    file_path = Rails.root.join("app/assets/images/default_images/#{image}")
    post.images.attach(io: File.open(file_path), filename: image, content_type: 'image/jpeg')
  end
  post.save!
end

puts "３種類の投稿の設定完了"

# タグの設定
tags_sets = ["京都", "清水寺", "観光地", "世界遺産", "北海道", "時計台", "福井県", "海", "絶景"]
tags_sets.each do |tag_name|
  Tag.create!(name: tag_name)
end

# タグの中間テーブルの設定
PostTag.create!(tag: Tag.find(1), post: Post.find(1))
PostTag.create!(tag: Tag.find(2), post: Post.find(1))
PostTag.create!(tag: Tag.find(3), post: Post.find(1))
PostTag.create!(tag: Tag.find(4), post: Post.find(1))
PostTag.create!(tag: Tag.find(3), post: Post.find(2))
PostTag.create!(tag: Tag.find(5), post: Post.find(2))
PostTag.create!(tag: Tag.find(6), post: Post.find(2))
PostTag.create!(tag: Tag.find(7), post: Post.find(3))
PostTag.create!(tag: Tag.find(8), post: Post.find(3))
PostTag.create!(tag: Tag.find(9), post: Post.find(3))
PostTag.create!(tag: Tag.find(3), post: Post.find(3))

puts "タグの設定完了"

# コメントの設定
text = ['素敵ですね！', '私もいつか行ってみたいです!', '物凄く迫力のある景色でした！是非一度訪れてみてください！']
3.times do |n|
  Comment.create!(
    user: User.find(n + 1),
    post: Post.find(3),
    text: text[n]
  )
end

puts "投稿に対するコメントの設定完了"

# グループチャットの設定
RoomGroup.create!(
  name: "観光地好き集まれ！！",
  group_description: "観光地に訪れるのが好きな方は是非ご参加ください！！"
)

# グループチャットのユーザー管理(中間テーブル)の設定
5.times do |n|
  leader = (n + 1 == 1)
  UserGroup.create!(
    user: User.find(n + 1),
    room_group: RoomGroup.find(1),
    is_leader: leader
  )
end

# グループチャットのメッセージ管理(中間テーブル)の設定
5.times do |n|
  MessageGroup.create!(
    user: User.find(n + 1),
    room_group: RoomGroup.find(1),
    text: "私がデフォルトユーザーのNo.#{n + 1}です！"
  )
end

puts "グループチャットの設定完了"

# レビューの設定
Rate.create!(
  user: User.find(1),
  star: '3',
  text: '普通かなと思います。'
)

puts "レビューの設定完了"

# 違反報告の設定
Violate.create!(
  reporter: User.find(1),
  reported: User.find(2),
  text: 'この投稿は著作権侵害に該当するのではないでしょうか？',
  status: 1,
  post: Post.find(2)
)

puts "違反投稿の設定完了"

# 管理者側の通知設定(レビュー)
AdminNotification.create!(
  visitor_id: User.find(1).id,
  rate: Rate.find(1),
  action: 'rate'
)

puts "管理者側の通知設定(レビュー)の設定完了"

# 管理者側の通知設定(違反報告)
AdminNotification.create!(
  visitor_id: User.find(1).id,
  violate: Violate.find(1),
  action: 'violate'
)

puts "管理者側の通知設定(違反報告)の設定完了"

puts "seedの実行が完了しました"