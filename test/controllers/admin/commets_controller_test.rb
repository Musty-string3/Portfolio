require "test_helper"

class Admin::CommetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_commets_index_url
    assert_response :success
  end
end
