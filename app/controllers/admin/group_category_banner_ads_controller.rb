# frozen_string_literal: true

class ::DiscourseGroupCategoryBannerAds::AdminGroupCategoryBannerAdsController < Admin::AdminController
  def index
    # render_serialized(
    #   { banner_ads: DiscourseGroupCategoryBannerAds::BannerAd.all.order(:created_at) },
    #   DiscourseGroupCategoryBannerAds::BannerAdIndexSerializer,
    #   root: false,
    # )
    render json: { hello: "world" }
  end

  def set_category_ids_for_ad
    params.require(:id)
    # BannerAd.find_or_create_by(id: params[:id])
  end
end
