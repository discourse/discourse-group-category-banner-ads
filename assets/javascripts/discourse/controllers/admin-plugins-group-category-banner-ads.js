import Controller from "@ember/controller";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import { TrackedObject } from "@ember-compat/tracked-built-ins";
import { extractError } from "discourse/lib/ajax-error";
import EmberObject from "@ember/object";

export default class AdminPluginsGroupCategoryBannerAds extends Controller {
  @service toasts;

  @tracked editing = false;
  @tracked creating = false;
  @tracked selectedCategories = [];
  @tracked bannerAd = new TrackedObject({});

  @action
  setEditing(bannerAd) {
    this.editing = true;
    this.bannerAd = new TrackedObject(bannerAd);
  }

  @action
  setCreating() {
    this.creating = true;
    this.bannerAd = new TrackedObject({});
  }

  @action
  reset() {
    this.editing = false;
    this.creating = false;
  }

  @action
  saveBannerAd() {
    console.log(this.bannerAd?.id);
    if (this.bannerAd?.id) {
      this.updateBannerAd(this.bannerAd);
    } else {
      this.createBannerAd(this.bannerAd);
    }
  }

  @action
  setCategoryIds(categoryArray) {
    this.selectedCategories = categoryArray;

    if (!this.bannerAd.category_ids) {
      this.bannerAd.category_ids = [];
    }
    this.bannerAd.category_ids = new TrackedObject(
      categoryArray.map((c) => c.id)
    );
  }

  @action
  setBannerTitle(e) {
    this.bannerAd.title = e.target.value;
  }

  @action
  setCtaText(e) {
    this.bannerAd.cta_text = e.target.value;
  }

  @action
  setCtaUrl(e) {
    this.bannerAd.cta_url = e.target.value;
  }

  @action
  setBannerText(e) {
    this.bannerAd.banner_text = e.target.value;
  }

  @action
  setEnabled(e) {
    this.bannerAd.enabled = e.target.checked;
  }

  @action
  async createBannerAd() {
    try {
      const data = {
        title: this.bannerAd.title,
        banner_text: this.bannerAd.banner_text,
        category_ids: this.bannerAd.category_ids?.map((c) => c),
        group_ids: this.bannerAd.group_ids,
        cta_url: this.bannerAd.cta_url,
        cta_text: this.bannerAd.cta_text,
        enabled: this.bannerAd.enabled || false,
      };
      const response = await ajax(
        "/admin/plugins/group_category_banner_ads.json",
        {
          data,
          type: "POST",
        }
      );
      this.toasts.success({
        duration: 3000,
        data: { message: "Banner ad created successfully!" },
      });
      this.model.banner_ads.unshiftObject(
        EmberObject.create(response.banner_ad)
      );
      this.reset();
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: { message: extractError(error) },
      });
    }
  }

  @action
  async updateBannerAd(bannerAd) {
    const data = {
      id: bannerAd.id,
      title: bannerAd.title,
      banner_text: bannerAd.banner_text,
      category_ids: bannerAd.category_ids?.map((c) => c),
      group_ids: bannerAd.group_ids,
      cta_url: bannerAd.cta_url,
      cta_text: bannerAd.cta_text,
      enabled: bannerAd.enabled,
    };
    try {
      await ajax(
        `/admin/plugins/group_category_banner_ads/${bannerAd.id}.json`,
        {
          data,
          type: "PUT",
        }
      );
      this.toasts.success({
        duration: 3000,
        data: { message: "Banner ad updated successfully!" },
      });
      this.set(
        "model.banner_ads",
        this.model.banner_ads.map((b) => {
          if (b.id === bannerAd.id) {
            return EmberObject.create(data);
          }
          return b;
        })
      );
      this.reset();
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: { message: extractError(error) },
      });
    }
  }

  @action
  deleteBannerAd(bannerAd) {}
}
