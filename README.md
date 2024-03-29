# My Favorite Tourist Spot
https://portfolio-mfts.com/
<br>
※新規登録をせずにゲストログインからログインできます。
<br>
※レスポンシブ対応していますので、スマートフォンからでも利用できます。
## サイト概要

### サイトテーマ
訪れてみたい観光地や絶景スポットを検索したり、おすすめの観光地を画像と文章を使って投稿することができるSNSアプリケーション。

### テーマを選んだ理由
自然に囲まれた場所である秘境や絶景スポット、歴史的建造物のある観光地に訪れることが好きで、あまり知られていない観光地から有名な観光地までを探す、共有ができるサービスがあれば便利だと考えました。<br>
そこで、観光地を探したり、投稿に対してコメントやいいねをすることで、今話題になっている人気スポットを探したり、交流する場を作ることができれば、観光地好きの方にとって需要のあるアプリケーションになると思い、今回のテーマに選定しました。

### ターゲットユーザー
・観光地を訪れるのが好きな人<br>
・旅行へ行きたいけど、有名な観光地を知らない人<br>
・おすすめの観光地を宣伝したい人<br>

<!--### 主な利用シーン-->
<!--・観光地の検索をしたい時<br>-->
<!--・実際に観光地へ訪れた人の感想を知りたい時<br>-->
<!--・お気に入りの観光地を紹介したい時-->

### 画面紹介
※画面に収まりきらない箇所は切り取り、画面のサイズを変更して表示しています。

・トップページ画面
![スクリーンショット 2023-12-17 110439](https://github.com/Musty-string3/Portfolio/assets/138371972/ee697273-ddfd-4b59-bdc8-db93cfd02711)
・投稿一覧画面
![スクリーンショット 2024-01-16 193658](https://github.com/Musty-string3/Portfolio/assets/138371972/87e0aa6e-b586-49ca-beed-58851aa57f4b)・投稿詳細画面
![スクリーンショット 2023-12-17 111621](https://github.com/Musty-string3/Portfolio/assets/138371972/17c53811-370a-43c3-b87b-560ed366447d)
・DM画面
![スクリーンショット 2023-12-17 111414](https://github.com/Musty-string3/Portfolio/assets/138371972/54e85464-9fe6-401f-8e54-5c590cc9b4d1)
・管理者投稿詳細画面
![スクリーンショット 2023-12-17 111840](https://github.com/Musty-string3/Portfolio/assets/138371972/28faa59d-4095-424d-97bc-a2b90da2d98d)
・ユーザー画面（スマートフォンからの閲覧）
<br>
![IMG_2180](https://github.com/Musty-string3/Portfolio/assets/138371972/ff4e3f19-9987-48f2-a3a1-d0c1dd442bbc)
<br>

## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby(3.1.2),SQL(MySQL,SQLite)
- フレームワーク：Ruby on Rails(6.1.7.4)
- CSSフレームワーク：Bootstrap
- JSライブラリ：jQuery
- IDE：Cloud9
- 外部API：Google Map API
- AWS：VPC,EC2,RDS,CloudWatch,Route53
- Webサーバー：Nginx
- アプリケーションサーバー：Puma
- CI/CD：Github Action


## 機能一覧
- ユーザー機能、ログイン機能(devise)
- 投稿機能
  - 複数画像投稿
  - タグの設定
  - Google Mapでの位置情報の共有(Google Map API)
  - 投稿の閲覧数の表示
- いいね機能(Ajax)
  - いいねした投稿の一覧表示
- コメント機能(Ajax)
  - コメントに対してのいいね機能(Ajax)
- フォロー機能(Ajax)
  - 相互フォローのみ可能なDM機能(Ajax)
- 検索機能
  - ユーザー、投稿検索(あいまい検索)
- 通知機能
  - ユーザー側
    - いいね、コメント、フォロー
  - 管理者側
    - サイトのレビュー、投稿の違反報告
- タイムライン
- 新規投稿、いいね、直近のいいね順で投稿を表示
- グループチャット機能(Ajax)
- サイトのレビュー機能
- 投稿の違反報告機能
- ページネーション機能(kaminari)


## 各種設計書
・[テーブル定義書](https://docs.google.com/spreadsheets/d/1C2OvCG1tq4fb6f-WZ8_k6HbQAxL5LO7q3VX3m3E6ph8/edit?usp=sharing)
<br>
・[アプリケーション詳細設計書](https://docs.google.com/spreadsheets/d/1YGal3kW0m1_xQ2BkjpuFXbKufiPfGzwLXzzrgtBfCGM/edit?usp=sharing)
<!--<br>-->
<!--・[テスト仕様書](https://docs.google.com/spreadsheets/d/1N3pCvhcvuvnswRpplxmZ9w_hFBibk_51/edit?usp=sharing&ouid=100955468655227652432&rtpof=true&sd=true)-->

## ER図
![スクリーンショット 2023-12-27 223416](https://github.com/Musty-string3/Portfolio/assets/138371972/8b23c28c-795f-4144-b143-a95a8f285370)


## AWS構成
![スクリーンショット 2023-12-10 163145](https://github.com/Musty-string3/Portfolio/assets/138371972/3d863dea-ec60-4434-9dcc-c003260451e7)
<br>
[インフラ設計書](https://docs.google.com/spreadsheets/d/11iRUtiFyHCkW8v-feDjLazGbTwt0afiEIqfULL21ujc/edit?usp=sharing)


## 意識した、こだわった部分
##### 可読性のあるコードを書くために
第三者目線から見ても理解しやすい可読性のあるコードを書くことを重点的に意識しました。<br>
また、重複している箇所は部分テンプレート、メソッド化を行い、DRY原則の徹底を行いました。

##### N+1問題の対策
現在は規模が小さいアプリケーションですが、無駄なSQLを発行してしまうことはアプリケーションの性能が落ちてしまうことに繋がると考えています。
そのため、内部結合や外部結合を用いて必要なデータのみ取得する考え方を取り入れました。

##### レスポンシブ対応
現代ではスマートフォンからのアクセスが大多数であるため、スマートフォンからでも利用できるアプリケーションにしました。


## 苦労したこと
##### 新しい技術の習得
これまで学んできた技術のみでは実現不可な機能が多く、ポートフォリオ制作に入ってからは常に新しい知識、技術の学習でした。<br>
制作の前半部分では、フォロー機能のアソシエーション関連、ActiveRecordのクエリ操作に戸惑いましたが、頭で考えるよりも、とにかく手を動かしてコードの1つ1つの挙動を理解していく積極的な実践と試行錯誤が大切だと学びました。<br>
制作の後半では、JavaScript、Bootstrapなど、新たな技術を学ぶ過程で苦戦しましたが、ドキュメントを見ながら学習を進めていくことが成功への近道だということを学ぶとともに、理論だけでなく実際のコーディング作業が欠かせないことも学びました。

##### 新しいエラーの解消法
新しいことを学ぶことで今まで表示されてこなかったエラーが表示されるようになり、実装機能の学習だけでなく、エラーの学習も同時並行で学ぶ必要がありました。<br>
とにかく覚えることが多くて大変でしたが、エラーの解消法を理解することで開発のスピードが格段と速くなり、自己成長を感じられることがポートフォリオ制作の楽しさでもあり、やりがいでもありました。

##### AWS、Web知識の学習
プログラミングだけでなく、ネットワーク周りの学習も行ってきました。<br>
実際にAWSの構成やインフラ、デプロイ後のWebが表示されるプロセスなどの構造を理解するまでが大変苦労しました。
現在もまだ理解しきれていない部分はかなり多いですが、ネットワークの知識は、アプリケーションのパフォーマンスやセキュリティにも直結するため、
プログラムが実際にどのように動作し、データがやり取りされるかを理解することで、また違った視点から開発ができるのではないかと思っています。


## 今後チャレンジしたいこと
- パスワード再設定
- ユーザー新規登録時に自動メール送信機能
- Rspecを用いたテスト
- erb以外のテンプレートエンジン(slim/haml)を用いてhtml.erbを書き換える
- Rubyの静的コード解析ツールであるRubocopを使ってコーディング規約の確認

## 使用素材
[イラストAC](https://www.ac-illust.com/)
<br>
[ぱくたそ](https://www.pakutaso.com/)