class Admin::ViolatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @violates = Violate.all
  end
end
