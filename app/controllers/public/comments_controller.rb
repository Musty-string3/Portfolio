class Public::CommentsController < ApplicationController
  
  def create
    comment = current_user.comments.new(comment_params)
    comment.post_id = Post.find(params[:post_id]).id
    comment.save
    @post = Post.find(params[:post_id])
    @comment = Comment.new
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:text)
  end
end
