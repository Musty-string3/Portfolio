class Admin::RatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rate = Rate.includes(:user).all
    # 平均点を整数で求める
    @average_rate = Rate.average(:star).to_i
  end

  def show
  end
end
