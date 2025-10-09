import Component from "@glimmer/component";
import { service } from "@ember/service";
import BannerAd from "../../components/banner-ad";

const bannerCategoriesIncludesCategory = (categoryId, bannerCategoryIds) => {
  return bannerCategoryIds.includes(categoryId);
};

export default class BannerAds extends Component {
  @service site;

  <template>
    {{#each this.site.banner_ads as |banner|}}
      {{#if
        (bannerCategoriesIncludesCategory @category.id banner.category_ids)
      }}
        <BannerAd @banner={{banner}} />
      {{/if}}
    {{/each}}
  </template>
}
