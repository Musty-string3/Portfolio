class Admin::RatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rate = Rate.includes(:user).all
  end

  def show
  end
end
