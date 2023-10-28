class Public::TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.includes(:user)
  end
end
