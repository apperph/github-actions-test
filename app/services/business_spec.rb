class BusinessSpec
  SPEC_PATH = Rails.root.join("config/specs/business.yml")

  def self.data
    @data ||= YAML.load_file(SPEC_PATH)
  end

  def self.reload!
    @data = YAML.load_file(SPEC_PATH)
  end

  def self.site
    data.fetch("site", {})
  end

  def self.features
    data.fetch("features", {})
  end

  def self.pricing
    data.fetch("pricing", {})
  end

  def self.workflow
    data.fetch("workflow", {})
  end

  def self.enabled?(feature_name)
    features[feature_name.to_s] == true
  end
end
