require "test_helper"

class Admin::ViolatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_violates_index_url
    assert_response :success
  end
end
