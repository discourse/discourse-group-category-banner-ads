import EmberObject from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";

export default class AdminPluginsGroupCategoryBannerAds extends DiscourseRoute {
  async model() {
    const response = await ajax(
      "/admin/plugins/group_category_banner_ads.json"
    );
    response.banner_ads = response.banner_ads.map((ba) =>
      EmberObject.create(ba)
    );
    return response;
  }
}
