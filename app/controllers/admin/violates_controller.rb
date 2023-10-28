class Admin::ViolatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @violates = Violate.includes(:post, :reporter, :reported).all.order(created_at: :desc)
    AdminNotification.update_unchecked_violate_actions
  end
end
