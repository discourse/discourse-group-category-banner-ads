/* eslint-disable ember/route-path-style */

export default {
  resource: "admin.adminPlugins",
  path: "/plugins",
  map() {
    this.route("group_category_banner_ads");
  },
};
