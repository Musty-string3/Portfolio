class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @model = params[:model]  #user or postが入る
    @keyword  = params[:keyword] #ユーザーが検索した内容
    @model == 'user' ? (@records = User.search_for(@keyword)) : (@records = Post.search_for(@keyword))
  end
end
