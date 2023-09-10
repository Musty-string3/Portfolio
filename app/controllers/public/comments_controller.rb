class Public::CommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      @post.create_notification_comment!(current_user, @comment.id)
    else
      render :error
    end
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
