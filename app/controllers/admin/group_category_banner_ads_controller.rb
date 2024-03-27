# frozen_string_literal: true

class DiscourseGroupCategoryBannerAds::AdminGroupCategoryBannerAdsController < Admin::AdminController
  def index
    render json: ActiveModel::ArraySerializer.new(BannerAd.all, each_serializer: BannerAdSerializer, root: "banner_ads").as_json
  end

  def update 
    params.require(:id)
    # BannerAd.find_or_create_by(id: params[:id])
  end

  def create
    params.permit(:banner_text, :enabled, :cta_url, :cta_text, category_ids: [], group_ids: [])
    params.require(:banner_text)
    params.require(:enabled)
    BannerAd.create!(banner_text: params[:banner_text], enabled: params[:enabled], cta_url: params[:cta_url], cta_text: params[:cta_text], category_ids: params[:category_ids] || [], group_ids: params[:group_ids] || [])
  end
end
