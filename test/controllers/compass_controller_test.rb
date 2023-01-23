require "test_helper"

class CompassControllerTest < ActionDispatch::IntegrationTest
  test "should get find" do
    get compass_find_url
    assert_response :success
  end
end
