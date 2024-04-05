import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import BannerAd from "../../components/banner-ad";

const userHasBannerGroupsMembership = (bannerGroupIds, currentUser) => {
  return bannerGroupIds.some((g) =>
    currentUser.groups.map((ug) => ug.id).includes(g)
  );
};

const bannerGroupIdsEmpty = (bannerGroupIds) => {
  return bannerGroupIds.length === 0;
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
        {{else if (bannerGroupIdsEmpty banner.group_ids)}}
          {{! display for anon if group_ids are empty }}
          <BannerAd @banner={{banner}} />
        {{/if}}
      {{/if}}
    {{/each}}
  </template>
}
