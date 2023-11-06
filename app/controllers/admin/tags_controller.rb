class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    post_id = params[:post_id]
    tag_name = params[:tag_name]
    @keyword = params[:keyword]
    @post_tag = false
    @search_path = admin_tags_path
    # TODOメソッドにできる
    if @keyword.present? && @keyword != ""
      @tags = Tag.search_for(@keyword)
    elsif post_id.present?
      @tags = Tag.joins(:posts).where(posts: {id: post_id})
      @post_name = Post.find(post_id).post_name
      @post_tag = true
    elsif tag_name.present?
      @tags = Tag.where(name: tag_name)
    else
      @tags = Tag.includes(:posts).all.order(created_at: :desc)
    end
  end

end
