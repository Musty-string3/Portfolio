require "test_helper"

class Admin::TagsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_tags_show_url
    assert_response :success
  end
end
