class Public::TagsController < ApplicationController

  def show
    @tag = Tag.find(params[:id])
    @posts = Post.includes(:post_tags, :user).where(post_tags: {tag_id: params[:id]})
  end
end
