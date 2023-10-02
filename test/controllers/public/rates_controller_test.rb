require "test_helper"

class Public::RatesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_rates_new_url
    assert_response :success
  end
end
