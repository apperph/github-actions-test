require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page loads" do
    get root_url
    assert_response :success
    assert_match "spec-driven Rails app", response.body
  end
end
