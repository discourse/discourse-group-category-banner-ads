# frozen_string_literal: true

# name: discourse-group-category-banner-ads
# about: Display a banner ad on a category based on group membership
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_group_category_banner_ads_enabled

module ::DiscourseGroupCategoryBannerAds
  PLUGIN_NAME = "discourse-group-category-banner-ads"
end

require_relative "lib/discourse_group_category_banner_ads/engine"

after_initialize do
  # ../app/models/group_category_banner_ads.rb
  %w[
    ../app/controllers/admin/group_category_banner_ads_controller.rb
  ].each { |path| load File.expand_path(path, __FILE__) }

  add_admin_route "discourse_group_category_banner_ads.admin.title", "group_category_banner_ads"

  Discourse::Application.routes.prepend do
    mount ::DiscourseGroupCategoryBannerAds::Engine, at: "/group_category_banner_ads"
    get "/admin/plugins/group_category_banner_ads" => "discourse_group_category_banner_ads/admin_group_category_banner_ads#index",
        :constraints => StaffConstraint.new
    post "/admin/plugins/group_category_banner_ads/:id/set_category_ids_for_ad" =>
      "discourse_group_category_banner_ads/admin_group_category_banner_ads#set_category_ids_for_ad",
      :constraints => StaffConstraint.new
  end
end
