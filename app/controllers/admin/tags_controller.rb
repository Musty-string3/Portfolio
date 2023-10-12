class Admin::TagsController < ApplicationController
  
  def show
    @tag = Tag.find(params[:id])
  end
end
