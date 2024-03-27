# frozen_string_literal: true

class DiscourseGroupCategoryBannerAds::AdminGroupCategoryBannerAdsController < Admin::AdminController
  def index
    render json: {
      banner_ads: ActiveModel::ArraySerializer.new(BannerAd.all.order(created_at: :desc), each_serializer: BannerAdSerializer).as_json,
      categories: ActiveModel::ArraySerializer.new(Category.secured(@guardian), each_serializer: BasicCategorySerializer).as_json,
      groups: ActiveModel::ArraySerializer.new(Group.all, each_serializer: BasicGroupSerializer, scope: @guardian).as_json,
    }
  end

  def create
    banner_ad = BannerAd.create!(banner_ad_params)
    render json: banner_ad
  end

  def update
    params.require(:id)
    banner_ad = BannerAd.find(params[:id])
    banner_ad.update!(banner_ad_params)
    render json: banner_ad
  end

  def destroy
    params.require(:id)
    banner_ad = BannerAd.find(params[:id])
    banner_ad.destroy!
    render json: success_json
  end

  private

  def banner_ad_params
    params.permit(:title, :banner_text, :enabled, :cta_url, :cta_text, category_ids: [], group_ids: [])
          .transform_keys(&:to_sym)
  end
end