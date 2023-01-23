require "test_helper"

class PointControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get point_create_url
    assert_response :success
  end

  test "should get edit" do
    get point_edit_url
    assert_response :success
  end

  test "should get remove" do
    get point_remove_url
    assert_response :success
  end
end
