class Public::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      @post.create_notification_comment!(current_user, @comment.id)
    else
      flash.now[:error] = "コメントの作成に失敗しました"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    Comment.find(params[:id]).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
