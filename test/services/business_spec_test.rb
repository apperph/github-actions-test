require "test_helper"

class BusinessSpecTest < ActiveSupport::TestCase
  test "loads site headline" do
    assert BusinessSpec.site["headline"].present?
  end

  test "has pricing data" do
    assert BusinessSpec.pricing["plan_name"].present?
  end

  test "has onboarding steps" do
    assert BusinessSpec.workflow["onboarding_steps"].is_a?(Array)
  end
end
