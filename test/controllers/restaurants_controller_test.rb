require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get restaurants_search_url
    assert_response :success
  end
end
