class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    post_id = params[:post_id]
    @keyword = params[:keyword]
    @post_name = PostTag.find_by(post_id: post_id).post.post_name if post_id.present?
    @tags = Tag.search_keyword_present(post_id, @keyword).page(params[:page]).per(10)
    @search_path = admin_tags_path
  end

end