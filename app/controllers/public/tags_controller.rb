class Public::TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    @tag = Tag.find(params[:id])
    @tag_posts = Post.related_to_tag(@tag)
  end
end
