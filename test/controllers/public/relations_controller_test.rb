require "test_helper"

class Public::RelationsControllerTest < ActionDispatch::IntegrationTest
  test "should get followings" do
    get public_relations_followings_url
    assert_response :success
  end

  test "should get followers" do
    get public_relations_followers_url
    assert_response :success
  end
end
