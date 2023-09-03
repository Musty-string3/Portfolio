class Public::LikesController < ApplicationController
  #ログインしていないユーザーは機能を使えない
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: params[:post_id])
    #params[:post_id]の意味はroutesでネストしたpostの
    like.save
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: params[:post_id])
    like.destroy
  end
  
end
