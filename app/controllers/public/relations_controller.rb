class Public::RelationsController < ApplicationController

  def followings # フォロー一覧
    @users = User.find(params[:user_id]).followings
  end

  def followers # フォロワー一覧
    @users = User.find(params[:user_id]).followers
  end

  def create #フォローする
    @user = User.find(params[:user_id])
    current_user.relations.create(followed_id: params[:user_id])
    @user.create_notification_follow!(current_user)
  end

  def destroy #フォロー外す
    @user = User.find(params[:user_id])
    current_user.relations.find_by(followed_id: params[:user_id]).destroy
    # redirect_to request.referer 前のページに戻る redirect_backではない
  end
end
