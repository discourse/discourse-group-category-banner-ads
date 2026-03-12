/* eslint-disable ember/route-path-style */

export default {
  resource: "admin.adminPlugins",
  path: "/plugins",
  map() {
    this.route("group-category-banner-ads", {
      path: "group_category_banner_ads",
    });
  },
};
