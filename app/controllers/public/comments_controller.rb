class Public::CommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    render :error unless @comment.save
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    comment = Comment.find(params[:id])
    comment.destroy
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:text)
  end
end
