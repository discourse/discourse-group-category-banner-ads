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
    ../app/controllers/discourse_group_category_banner_ads/admin/admin_group_category_banner_ads_controller.rb
    ../app/serializers/discourse_group_category_banner_ads/basic_banner_ad_serializer.rb
    ../app/serializers/discourse_group_category_banner_ads/detailed_banner_ad_serializer.rb
    ../app/models/discourse_group_category_banner_ads/banner_ad.rb
  ].each { |path| load File.expand_path(path, __FILE__) }

  add_admin_route "discourse_group_category_banner_ads.admin.title", "group_category_banner_ads"

  Discourse::Application.routes.prepend do
    mount ::DiscourseGroupCategoryBannerAds::Engine, at: "/group_category_banner_ads"
    get "/admin/plugins/group_category_banner_ads" =>
          "discourse_group_category_banner_ads/admin/admin_group_category_banner_ads#index",
        :constraints => StaffConstraint.new
    post "/admin/plugins/group_category_banner_ads" =>
           "discourse_group_category_banner_ads/admin/admin_group_category_banner_ads#create",
         :constraints => StaffConstraint.new
    put "/admin/plugins/group_category_banner_ads/:id" =>
          "discourse_group_category_banner_ads/admin/admin_group_category_banner_ads#update",
        :constraints => StaffConstraint.new
    post "/admin/plugins/group_category_banner_ads/:id" =>
           "discourse_group_category_banner_ads/admin/admin_group_category_banner_ads#destroy",
         :constraints => StaffConstraint.new
  end



  # TopicList.on_preload do |topics, topic_list| 
  #   # binding.pry
  #   if topic_list.category
  #     topic_list.category.custom_fields["test"] = "string" 
  #     topic_list = topic_list
  #   end
  # end

  # register_category_custom_field_type("test", :string)

  reloadable_patch do
    # Category.register_custom_field_type("banner_ads", :boolean)
    # register_preloaded_category_custom_fields("banner_ads")
    # Site.preloaded_category_custom_fields << "banner_ads"
  end

  # add_to_serializer(:basic_category, :test) do
  #   "foo"
  # end

  # add_to_serializer(:basic_category, :banner_ads) do
  #   binding.pry
  #   "basic_test"
  # end

  # add_to_serializer(:category_detailed, :banner_ads) do
  #   binding.pry
  #   "detailed_test"
  # end

  # add_to_class(:category, :banner_ads) do
    # []
    # puts self.inspect"gooc"
  # end

  add_to_serializer(:site, :banner_ads) do
    if !scope&.user 
      return []
    end

    banner_ads =
      DiscourseGroupCategoryBannerAds::BannerAd
        .where(enabled: true)
        .where("category_ids && (?)", Category.secured(scope).select("ARRAY_AGG(categories.id)"))
        .where("group_ids && (?)", scope.user.groups.select("ARRAY_AGG(groups.id)"))

    ActiveModel::ArraySerializer.new(
      banner_ads,
      each_serializer: DiscourseGroupCategoryBannerAds::BasicBannerAdSerializer,
      root: false,
    ).as_json
  end
end
