import RouteTemplate from "ember-route-template";
import BannerForm from "../components/admin/banner-form";
import BannerTable from "../components/admin/banner-table";

export default RouteTemplate(
  <template>
    <BannerForm
      @creating={{@controller.creating}}
      @editing={{@controller.editing}}
      @bannerAd={{@controller.bannerAd}}
      @setBannerTitle={{@controller.setBannerTitle}}
      @setBannerText={{@controller.setBannerText}}
      @setCtaUrl={{@controller.setCtaUrl}}
      @setCtaText={{@controller.setCtaText}}
      @groups={{@controller.model.groups}}
      @categories={{@controller.model.categories}}
      @selectedCategories={{@controller.selectedCategories}}
      @setCategoryIds={{@controller.setCategoryIds}}
      @setGroupIds={{@controller.setGroupIds}}
      @selectedGroups={{@controller.selectedGroups}}
      @saveBannerAd={{@controller.saveBannerAd}}
      @reset={{@controller.reset}}
      @setCreating={{@controller.setCreating}}
      @setEnabled={{@controller.setEnabled}}
    />

    <BannerTable
      @bannerAds={{@controller.model.banner_ads}}
      @deleteBannerAd={{@controller.deleteBannerAd}}
      @setEditing={{@controller.setEditing}}
    />
  </template>
);
