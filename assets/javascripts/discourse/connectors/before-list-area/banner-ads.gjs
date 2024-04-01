import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import BannerAd from "../../components/banner-ad";

const userHasBannerGroupsMembership = (bannerGroupIds, currentUser) => {
  return (
    !!currentUser &&
    bannerGroupIds.some((g) =>
      currentUser.groups.map((ug) => ug.id).includes(g)
    )
  );
};

const bannerGroupsIncludesEveryone = (bannerGroupIds) => {
  return !!bannerGroupIds.includes(0);
};

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
        {{#if (bannerGroupsIncludesEveryone banner.group_ids)}}
          <BannerAd @banner={{banner}} />
        {{else if
          (userHasBannerGroupsMembership banner.group_ids this.currentUser)
        }}
          <BannerAd @banner={{banner}} />
        {{/if}}
      {{/if}}
    {{/each}}
  </template>
}
