class Public::UsersController < ApplicationController

  include TagCount  # app/concerns/tag_count.rbが使える
  before_action :authenticate_user!
  before_action :set_current_user, except: %i[show]

  def show
    @user = User.find(params[:id])
    @post_counts = Post.where(user_id: @user).count
    @user_posts = Post.includes(:user).where(user: { id: @user})
    @tag_counts = set_tag_count(@user_posts)
    # Relation.where(follow_id: 1).count　フォローしたカウント
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
    @posts = Post.includes(:likes).where(likes: {user_id: current_user.id})
    #Postに紐付いたlikesテーブルの中で自身がいいねした投稿を取り出す
    #where(likes: {user_id: current_user.id})でlikesテーブルのuser_id(current_user)がある部分を全取得する
    # @tag_lists = Tag.all
    @tag_counts = set_tag_count(@posts)
  end

  def timeline
    @posts = Post.where(user_id: [*current_user.followings.ids])
    #postsテーブルのuser_id(ログインしているユーザー)のフォローしているユーザーの全ての投稿を取得する
    #[*]は[1, 2, 3]と同じ意味で、末尾の.idsはwhereメソッドを使っているため複数のidを取得するから(idの複数形がids)
    @tag_counts = set_tag_count(@posts)
  end

  private

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :introduction, :profile_image)
  end
end
