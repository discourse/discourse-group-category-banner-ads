# frozen_string_literal: true

# name: discourse-group-category-banner-ads
# about: Display a banner ad on a category based on group membership
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_group_category_banner_ads_enabled

register_asset "stylesheets/common/banner-ads.scss"

module ::DiscourseGroupCategoryBannerAds
  PLUGIN_NAME = "discourse-group-category-banner-ads"
end

require_relative "lib/discourse_group_category_banner_ads/engine"

after_initialize do
  %w[
    ../app/controllers/admin/group_category_banner_ads_controller.rb
    ../app/serializers/basic_banner_ad_serializer.rb
    ../app/serializers/detailed_banner_ad_serializer.rb
    ../app/models/banner_ad.rb
  ].each { |path| load File.expand_path(path, __FILE__) }

  add_admin_route "discourse_group_category_banner_ads.admin.title", "group_category_banner_ads"

  Discourse::Application.routes.prepend do
    mount ::DiscourseGroupCategoryBannerAds::Engine, at: "/group_category_banner_ads"
    get "/admin/plugins/group_category_banner_ads" =>
          "discourse_group_category_banner_ads/admin_group_category_banner_ads#index",
        :constraints => StaffConstraint.new
    post "/admin/plugins/group_category_banner_ads" =>
           "discourse_group_category_banner_ads/admin_group_category_banner_ads#create",
         :constraints => StaffConstraint.new
    put "/admin/plugins/group_category_banner_ads/:id" =>
          "discourse_group_category_banner_ads/admin_group_category_banner_ads#update",
        :constraints => StaffConstraint.new
    post "/admin/plugins/group_category_banner_ads/:id" =>
           "discourse_group_category_banner_ads/admin_group_category_banner_ads#destroy",
         :constraints => StaffConstraint.new
  end

  reloadable_patch do
    add_to_serializer(:basic_category, :banner_ads) do
      ads_with_id =
        DiscourseGroupCategoryBannerAds::BannerAd.where(enabled: true).where(
          "category_ids @> ARRAY[?]",
          object.id,
        )
      ActiveModel::ArraySerializer.new(
        ads_with_id,
        each_serializer: DiscourseGroupCategoryBannerAds::BasicBannerAdSerializer,
        root: false,
      ).as_json
    end
  end
end
