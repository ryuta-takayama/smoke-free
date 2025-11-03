require "test_helper"

class DashbordsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get dashbords_show_url
    assert_response :success
  end
end
