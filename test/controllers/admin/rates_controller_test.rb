require "test_helper"

class Admin::RatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_rates_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_rates_show_url
    assert_response :success
  end
end
