# frozen_string_literal: true

class DiscourseGroupCategoryBannerAds::DetailedBannerAdSerializer < DiscourseGroupCategoryBannerAds::BasicBannerAdSerializer
  has_many :categories, serializer: BasicCategorySerializer, embed: :objects

  def categories
    Category.where(id: object[:category_ids])
  end

  def include_categories?
    object.category_ids.present?
  end
end
