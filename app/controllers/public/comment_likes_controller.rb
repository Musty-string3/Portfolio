class Public::CommentLikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = params[:post_id]
    @comment = params[:comment_id]
    CommentLike.create(
      comment_id: params[:comment_id],
      user_id: current_user.id
    )
  end

  def destroy
    @post = params[:post_id]
    @comment = params[:comment_id]
    CommentLike.find_by(
    user_id: current_user, comment_id: params[:comment_id]).destroy

    # CommentLike.find(params[:id])で取得したいときは
    # link_to 〇〇_path(id: comment.comment_likes.first.id)でターミナルに
    # Parameters:{ "id"=>"1" }のように送られてくる
  end
end
