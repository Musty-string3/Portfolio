class Public::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.create!(post_id: params[:post_id])
    @post.create_notification_like!(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.likes.find_by(post_id: params[:post_id]).destroy
  end

end
