class Public::TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    @tag = Tag.find(params[:id])
    @tag_posts = Post.joins(:user, :tags).where(tags:{name: @tag.name})
  end
end
