import EmberObject from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";

export default class AdminPluginsGroupCategoryBannerAds extends DiscourseRoute {
  model() {
    return ajax("/admin/plugins/group_category_banner_ads.json").then(
      (model) => {
        console.log(model); // currently hello world
        model.banner_ads = model.banner_ads.map((ad) => EmberObject.create(ad));
        return model;
      }
    );
  }
}
