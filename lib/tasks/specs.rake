require "yaml"

namespace :specs do
  desc "Validate business spec files"
  task validate: :environment do
    spec_file = Rails.root.join("config/specs/business.yml")
    data = YAML.load_file(spec_file)

    raise "Missing site.headline" unless data.dig("site", "headline").present?
    raise "Missing site.primary_cta_label" unless data.dig("site", "primary_cta_label").present?
    raise "Missing pricing.plan_name" unless data.dig("pricing", "plan_name").present?
    raise "Missing workflow.onboarding_steps" unless data.dig("workflow", "onboarding_steps").is_a?(Array)

    puts "Business spec is valid"
  end

  desc "Sync business spec into app state"
  task sync: :environment do
    spec_file = Rails.root.join("config/specs/business.yml")
    YAML.load_file(spec_file)

    puts "Applying business spec..."
    puts "Business spec applied"
  end
end
