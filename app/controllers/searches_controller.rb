class SearchesController < ApplicationController
  include TagCount

  def search
    @model = params[:model]
    @keyword  = params[:keyword]
    if @model == 'user'
      @records = User.search_for(@keyword)
    else
      @records = Post.search_for(@keyword)
    end
  end
end
