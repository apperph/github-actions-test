class PagesController < ApplicationController
  def home
    @site = BusinessSpec.site
    @features = BusinessSpec.features
    @pricing = BusinessSpec.pricing
    @workflow = BusinessSpec.workflow
  end
end
