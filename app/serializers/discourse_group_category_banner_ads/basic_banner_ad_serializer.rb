# frozen_string_literal: true

class DiscourseGroupCategoryBannerAds::BasicBannerAdSerializer < ApplicationSerializer
  attributes :id,
             :created_at,
             :title,
             :cta_url,
             :cta_text,
             :banner_text,
             :category_ids,
             :group_ids,
             :enabled
end
