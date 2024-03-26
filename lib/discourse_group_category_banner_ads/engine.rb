# frozen_string_literal: true

module ::DiscourseGroupCategoryBannerAds
  class Engine < ::Rails::Engine
    engine_name DiscourseGroupCategoryBannerAds
    isolate_namespace DiscourseGroupCategoryBannerAds
    config.autoload_paths << File.join(config.root, "lib")
  end
end
