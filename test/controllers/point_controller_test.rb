require "test_helper"

class PointControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = Faker::Lorem.word
    @user = User.create(email: Faker::Internet.email, password: @password)
  end

  test "should not get create" do
    post point_create_path
    assert_redirected_to new_user_session_path
  end

  test "should not get remove" do
    delete point_remove_path
    assert_redirected_to new_user_session_path
  end

  test "authed user can create points" do
    post user_session_path, params: { user: { email: @user.email, password: @password } }
    assert_changes('Point.count') do
      post point_create_path, params: { title: Faker::Lorem.word, description: Faker::Lorem.word, lon: Faker::Address.longitude, lat: Faker::Address.latitude }
    end
  end

  test "authed user can remove points" do
    post user_session_path, params: { user: { email: @user.email, password: @password } }
    assert_changes('Point.count') do
      post point_create_path, params: { title: Faker::Lorem.word, description: Faker::Lorem.word, lon: Faker::Address.longitude, lat: Faker::Address.latitude }
    end
    assert_changes('Point.count') do
      delete point_remove_path, params: { point_id: 1 }
    end
  end
end
