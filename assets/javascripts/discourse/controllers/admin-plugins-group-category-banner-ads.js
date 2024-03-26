import Controller from "@ember/controller";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class AdminPluginGroupCategoryBannerAds extends Controller {
  @action
  async setCategoryIdsForAd(id, categoryIds) {
    try {
      await ajax(
        `/admin/plugins/group_category_banner_ads/:id/set_category_ids_for_ad.json`,
        {
          data: { category_ids: categoryIds },
          type: "POST",
        }
      );
      banner_ad.set("category_ids", categoryIds.join("|"));
    } catch (error) {
      popupAjaxError(error);
    }
  }
}
