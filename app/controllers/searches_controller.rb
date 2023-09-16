class SearchesController < ApplicationController
  include TagCount
  before_action :authenticate_user!
  
  def search
    @model = params[:model]  #user or postが入る
    @keyword  = params[:keyword] #ユーザーが検索した内容
    if @model == 'user'
      @records = User.search_for(@keyword)
      # 検索にログインしているユーザーを表示させない
      # @records = User.search_for(@keyword).where.not(id: current_user.id)
    else
      @records = Post.search_for(@keyword)
      # 検索にログインしているユーザーの投稿を表示させない
      # @records = Post.search_for(@keyword).where.not(user_id: current_user.id)
    end
  end
end
