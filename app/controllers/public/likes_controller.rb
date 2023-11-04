class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post_id

  def create
    current_user.likes.create!(post_id: params[:post_id])
    @post.create_notification_like!(current_user, @post, params[:user_id])
  end

  def destroy
    current_user.likes.find_by(post_id: params[:post_id]).destroy
  end
  
  private
  
  def set_post_id
    @post = Post.find(params[:post_id])
  end

end
