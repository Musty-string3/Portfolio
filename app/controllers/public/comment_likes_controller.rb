class Public::CommentLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment_likes

  def create
    CommentLike.create(
      comment_id: params[:comment_id],
      user_id: current_user.id
    )
  end

  def destroy
    CommentLike.find_by(
    user_id: current_user, comment_id: params[:comment_id]).destroy

    # CommentLike.find(params[:id])で取得したいときは
    # link_to 〇〇_path(id: comment.comment_likes.first.id)でターミナルに
    # Parameters:{ "id"=>"1" }のように送られてくる
  end
  
  private
  
  def set_comment_likes
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:comment_id])
  end
end
