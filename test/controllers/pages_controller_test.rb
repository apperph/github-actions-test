require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page loads" do
    get root_url
    assert_response :success

    data = YAML.load_file(Rails.root.join("config/specs/business.yml"))

    assert_match data.dig("site", "headline"), @response.body
  end
end
