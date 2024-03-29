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

export default class BannerAds extends Component {
  @service currentUser;

  <template>
    {{#each @outletArgs.category.banner_ads as |banner|}}
      {{#if (bannerGroupsIncludesEveryone banner.group_ids)}}
        <BannerAd @banner={{banner}} />
      {{else if
        (userHasBannerGroupsMembership banner.group_ids this.currentUser)
      }}
        <BannerAd @banner={{banner}} />
      {{/if}}
    {{/each}}
  </template>
}
