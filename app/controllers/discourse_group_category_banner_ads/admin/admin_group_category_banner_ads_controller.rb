# frozen_string_literal: true

class DiscourseGroupCategoryBannerAds::Admin::AdminGroupCategoryBannerAdsController < Admin::AdminController
  def index
    render json: {
             banner_ads:
               ActiveModel::ArraySerializer.new(
                 DiscourseGroupCategoryBannerAds::BannerAd.all.order(created_at: :desc),
                 each_serializer: ::DiscourseGroupCategoryBannerAds::DetailedBannerAdSerializer,
               ).as_json,
             categories:
               ActiveModel::ArraySerializer.new(
                 Category.secured(@guardian),
                 each_serializer: BasicCategorySerializer,
               ).as_json,
             groups:
               ActiveModel::ArraySerializer.new(
                 Group.all,
                 each_serializer: BasicGroupSerializer,
                 scope: @guardian,
               ).as_json,
           }
  end

  def create
    banner_ad = DiscourseGroupCategoryBannerAds::BannerAd.create!(banner_ad_params)
    render json:
             DiscourseGroupCategoryBannerAds::DetailedBannerAdSerializer.new(
               banner_ad,
               root: false,
             ).as_json
  end

  def update
    params.require(:id)
    banner_ad = DiscourseGroupCategoryBannerAds::BannerAd.find(params[:id])
    # Ensure that we can clear the group_ids and category_ids
    updated_params = banner_ad_params
    updated_params.merge!(group_ids: []) unless params[:group_ids].present?
    updated_params.merge!(category_ids: []) unless params[:category_ids].present?
    banner_ad.update!(updated_params)

    render json:
             DiscourseGroupCategoryBannerAds::DetailedBannerAdSerializer.new(
               banner_ad,
               root: false,
             ).as_json
  end

  def destroy
    params.require(:id)
    banner_ad = DiscourseGroupCategoryBannerAds::BannerAd.find(params[:id])
    banner_ad.destroy!
    render json: success_json
  end

  private

  def banner_ad_params
    params.permit(
      :id,
      :title,
      :banner_text,
      :enabled,
      :cta_url,
      :cta_text,
      category_ids: [],
      group_ids: [],
    )
  end
end
