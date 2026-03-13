import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import EmberObject, { action } from "@ember/object";
import { service } from "@ember/service";
import { TrackedArray, TrackedObject } from "@ember-compat/tracked-built-ins";
import { ajax } from "discourse/lib/ajax";
import { extractError } from "discourse/lib/ajax-error";

export default class AdminPluginsGroupCategoryBannerAds extends Controller {
  @service toasts;

  @tracked editing = false;
  @tracked creating = false;
  @tracked selectedCategories = this.bannerAd.categories || [];
  @tracked selectedGroups = this.bannerAd.group_ids || [];
  @tracked bannerAd = new TrackedObject({});

  @action
  setEditing(bannerAd) {
    this.editing = true;
    this.bannerAd = new TrackedObject(bannerAd);

    this.resetGroupsAndCategories();
  }

  @action
  setCreating() {
    this.creating = true;
    this.bannerAd = new TrackedObject({});

    this.resetGroupsAndCategories();
  }

  @action
  reset() {
    this.editing = false;
    this.creating = false;
  }

  @action
  saveBannerAd() {
    if (this.validateInputs()) {
      if (this.bannerAd?.id) {
        this.updateBannerAd(this.bannerAd);
      } else {
        this.createBannerAd(this.bannerAd);
      }
    }
  }

  @action
  setCategoryIds(categoryArray) {
    this.selectedCategories = categoryArray;

    this.bannerAd.category_ids = new TrackedArray(
      categoryArray.map((c) => c.id)
    );
  }

  @action
  setGroupIds(groupIds) {
    this.selectedGroups = groupIds;
    this.bannerAd.group_ids = groupIds;
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
      this.model.banner_ads.unshiftObject(EmberObject.create(response));
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
      const response = await ajax(
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
            return EmberObject.create(response);
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
  async deleteBannerAd(bannerAd) {
    try {
      await ajax(
        `/admin/plugins/group_category_banner_ads/${bannerAd.id}.json`,
        {
          type: "POST",
        }
      );
      this.toasts.success({
        duration: 3000,
        data: { message: "Banner ad deleted successfully!" },
      });
      this.set(
        "model.banner_ads",
        this.model.banner_ads.filter((b) => b.id !== bannerAd.id)
      );
      this.reset();
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: { message: extractError(error) },
      });
    }
  }

  validateInputs() {
    if (!this.bannerAd.title) {
      this.toasts.error({
        duration: 3000,
        data: { message: "Title is required!" },
      });
      return false;
    }

    if (!this.bannerAd.banner_text) {
      this.toasts.error({
        duration: 3000,
        data: { message: "Banner text is required!" },
      });
      return false;
    }

    return true;
  }

  resetGroupsAndCategories() {
    // we need to reset the values in case they were changed during an edit then cancelled
    this.selectedCategories = this.bannerAd.categories || [];
    this.selectedGroups = this.bannerAd.group_ids || [];
  }
}
