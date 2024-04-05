import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import BannerAd from "../../components/banner-ad";

const bannerCategoriesIncludesCategory = (categoryId, bannerCategoryIds) => {
  return bannerCategoryIds.includes(categoryId);
};

export default class BannerAds extends Component {
  @service currentUser;

  <template>
    {{#each @outletArgs.category.site.banner_ads as |banner|}}
      {{#if
        (bannerCategoriesIncludesCategory
          @outletArgs.category.id banner.category_ids
        )
      }}
        <BannerAd @banner={{banner}} />
      {{/if}}
    {{/each}}
  </template>
}
