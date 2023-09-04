class Public::RelationsController < ApplicationController
  
  def followings # フォロー一覧
    @users = User.find(params[:user_id]).followings
  end

  def followers # フォロワー一覧
    @users = User.find(params[:user_id]).followers
  end
  
  def create #フォローする
    current_user.relations.create(followed_id: params[:user_id])
    redirect_to request.referer
  end
  
  def destroy #フォロー外す
    current_user.relations.find_by(followed_id: params[:user_id]).destroy
    redirect_to request.referer
  end
end
