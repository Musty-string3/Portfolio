class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @post_id = params[:post_id]
    @keyword = params[:keyword]
    tag_name = params[:tag_name]
    @tags = Tag.search_keyword_present(@post_id, @keyword, tag_name).page(params[:page]).per(10)
    @search_path = admin_tags_path
  end

end