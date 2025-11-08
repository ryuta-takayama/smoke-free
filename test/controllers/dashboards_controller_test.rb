require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "tester@example.com",
      password: "Passw0rd",
      password_confirmation: "Passw0rd",
      nickname: "tester",
      age: 25,
      reason_to_quit: :health
    )
  end

  test "should get show" do
    sign_in @user
    get dashbords_path
    assert_response :success
  end
end
