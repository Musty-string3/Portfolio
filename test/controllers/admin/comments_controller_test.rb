require "test_helper"

class Admin::CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get admin_comments_search_url
    assert_response :success
  end
end
