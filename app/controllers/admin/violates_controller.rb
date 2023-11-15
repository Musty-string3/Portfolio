class Admin::ViolatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @violates = Violate.ordered_by_created_at_desc
    AdminNotification.update_unchecked_actions('violate')
  end
end
