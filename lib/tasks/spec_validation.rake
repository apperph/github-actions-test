namespace :spec do
  desc "Validate business spec"
  task validate: :environment do
    data = YAML.load_file(Rails.root.join("config/specs/business.yml"))

    raise "Missing site.headline" unless data.dig("site", "headline").present?
    raise "Missing site.primary_cta_label" unless data.dig("site", "primary_cta_label").present?
    raise "Missing pricing.plan_name" unless data.dig("pricing", "plan_name").present?
    raise "Missing workflow.onboarding_steps" unless data.dig("workflow", "onboarding_steps").is_a?(Array)

    puts "Business spec is valid"
  end
end
