class Admin::RatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rate = Rate.for_users_created_desc
    @average_rate = Rate.average(:star).to_i
    AdminNotification.update_unchecked_rate_actions
  end
end
