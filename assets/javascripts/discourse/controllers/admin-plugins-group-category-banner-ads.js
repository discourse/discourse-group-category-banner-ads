import Controller from "@ember/controller";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import { TrackedObject } from "@ember-compat/tracked-built-ins";
import { extractError } from "discourse/lib/ajax-error";

export default class AdminPluginsGroupCategoryBannerAds extends Controller {
  @service toasts;

  @tracked editing = false;
  @tracked creating = false;
  bannerAd = new TrackedObject();

  @action
  setEditing(bannerAd) {
    this.editing = !this.editing;
    if (bannerAd) {
      this.bannerAd = new TrackedObject(bannerAd);
    }
  }

  @action
  setCreating() {
    this.creating = !this.creating;
    this.bannerAd = new TrackedObject();
  }

  @action
  saveBannerAd() {
    if (this.bannerAd?.id) {
      this.updateBannerAd(this.bannerAd);
    } else {
      this.createBannerAd(this.bannerAd);
    }
  }

  @action
  setCtaText(e) {
    this.bannerAd.ctaText = e.target.value;
  }

  @action
  setCtaUrl(e) {
    this.bannerAd.ctaUrl = e.target.value;
  }

  @action
  setBannerText(e) {
    this.bannerAd.bannerText = e.target.value;
  }

  @action
  setEnabled(e) {
    this.bannerAd.enabled = e.target.value;
  }

  @action
  async createBannerAd() {
    try {
      await ajax("/admin/plugins/group_category_banner_ads.json", {
        data: {
          banner_text: this.bannerAd.bannerText,
          category_ids: this.bannerAd.categoryIds,
          group_ids: this.bannerAd.groupIds,
          cta_url: this.bannerAd.ctaUrl,
          cta_text: this.bannerAd.ctaText,
          enabled: this.bannerAd.enabled,
        },
        type: "POST",
      });
      this.toasts.success({
        duration: 3000,
        data: { message: "Banner ad created successfully!" },
      });
      this.setCreating();
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: { message: extractError(error) },
      });
    }
  }

  @action
  async updateBannerAd() {
    try {
      await ajax(
        `/admin/plugins/group_category_banner_ads/${this.bannerAd.id}.json`,
        {
          data: { banner_ad: this.bannerAd },
          type: "PUT",
        }
      );
      this.toasts.success({
        duration: 3000,
        data: { message: "Banner ad updated successfully!" },
      });
      this.setEditing();
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: { message: extractError(error) },
      });
    }
  }

  // @action
  // async setCategoryIdsForAd(id, categoryIds) {
  //   try {
  //     await ajax(
  //       `/admin/plugins/group_category_banner_ads/:id/set_category_ids_for_ad.json`,
  //       {
  //         data: { category_ids: categoryIds },
  //         type: "POST",
  //       }
  //     );
  //     banner_ad.set("category_ids", categoryIds.join("|"));
  //   } catch (error) {
  //     popupAjaxError(error);
  //   }
  // }
}
