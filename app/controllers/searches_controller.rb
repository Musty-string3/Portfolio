class SearchesController < ApplicationController
  
  before_action :authenticate_user!
  
  def search
    model = params[:model]  #user or post
    keyword  = params[:keyword] #ユーザーが検索した内容
    if model == 'user'
      @records = User.search_for(keyword)
    else
      @records = Post.search_for(keyword)
    end
  end
end
