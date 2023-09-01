class Public::CommentsController < ApplicationController
  
  def create
    comment = current_user.comments.new(comment_params)
    post = Post.find(params[:post_id])
    comment.post_id = post.id
    comment.save ? (redirect_back fallback_location: root_path) : (redirect_back fallback_location: root_path)
  end
  
  def destroy
    Comment.find(params[:id]).destroy
    redirect_back fallback_location: root_path
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:text)
  end
end
