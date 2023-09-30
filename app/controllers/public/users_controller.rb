class Public::UsersController < ApplicationController

  include TagCount  # app/concerns/tag_count.rbが使える
  before_action :authenticate_user!
  before_action :set_current_user, except: %i[show]
  before_action :guest_user, only: %i[edit_information update withdrawal]

  def show
    @user = User.find(params[:id])
    @post_counts = Post.where(user_id: @user).count
    @user_posts = Post.includes(:user).where(user: { id: @user})
    # タグ機能
    tags = User.tag_joins_posts.where(posts: {user_id: @user})
    @tags = set_tag_count(tags)
    # DMしている人数
    @entries = Entry.where(user_id: @user.id).count
    # DM機能
    current_user_entry = Entry.where(user_id: current_user)
    user_entry = Entry.where(user_id: @user)
    @isRoom = false
    unless @user == current_user
      current_user_entry.each do |current|
        user_entry.each do |user|
          # ログインユーザーとフォローしているユーザーのroom_idが一致した場合
          if current.room_id == user.room_id
            @isRoom = true
            @room_id = current.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end


  def edit_information
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "会員情報の編集に成功しました。"
    else
      render :edit_information, notice: "会員情報の編集に失敗しました。再度内容をご確認ください。"
    end
  end

  def unsubscribe
  end

  def withdrawal
    @user.update(is_deleted: true)  #is_deletedをtrueに変更する
    reset_session                   #セッション情報を全て削除
    redirect_to root_path, notice: "退会処理を実行いたしました"
  end

  def likes
    @posts = Post.includes(:likes).where(likes: {user_id: current_user.id}).where.not(user_id: current_user.id)
    #Postに紐付いたlikesテーブルの中で自身がいいねした投稿を取り出す
    #where(likes: {user_id: current_user.id})でlikesテーブルのuser_id(current_user)がある部分を全取得する
    tags = User.tag_joins_posts.where(posts: {id: @posts.ids})
    @tags = set_tag_count(tags)
  end

  def timeline
    @posts = Post.where(user_id: [*current_user.followings.ids])
    #postsテーブルのuser_id(ログインしているユーザー)のフォローしているユーザーの全ての投稿を取得する
    #[*]は[1, 2, 3]と同じ意味で、末尾の.idsはwhereメソッドを使っているため複数のidを取得するから(idの複数形がids)
    tags = User.tag_joins_posts.where(posts: {user_id: [*current_user.followings.ids]})
    @tags = set_tag_count(tags)
  end

  private

  def set_current_user
    @user = current_user
  end

  # ゲストユーザーはプロフィール編集ができないよう設定している
  def guest_user
    if @user.email == 'guest@sample.com'
      redirect_back fallback_location: root_path
      flash[:notice] = "ゲストユーザーのプロフィール編集はできません。"
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :profile_image)
  end
end
