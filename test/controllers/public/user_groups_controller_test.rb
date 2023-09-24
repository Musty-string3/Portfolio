require "test_helper"

class Public::UserGroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_user_groups_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_user_groups_edit_url
    assert_response :success
  end
end
