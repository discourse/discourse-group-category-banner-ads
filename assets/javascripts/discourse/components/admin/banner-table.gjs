import { fn } from "@ember/helper";
import DButton from "discourse/components/d-button";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";

const BannerTable = <template>
  <div class="index-banner-ads-container">
    <table>
      <thead>
        <tr>
          <th>
            {{i18n "discourse_group_category_banner_ads.title.label"}}
          </th>
          <th>
            {{i18n "discourse_group_category_banner_ads.cta_url.label"}}
          </th>
          <th>
            {{i18n "discourse_group_category_banner_ads.category_ids.label"}}
          </th>
          <th>
            {{i18n "discourse_group_category_banner_ads.group_ids.label"}}
          </th>
          <th>
            {{i18n "discourse_group_category_banner_ads.enabled.label"}}
          </th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        {{#each @bannerAds as |bannerAd|}}
          <tr>
            <td>
              <span class="banner-ad-table-title">
                {{bannerAd.title}}
              </span>
            </td>
            <td>
              <span class="banner-ad-table-cta-url">
                {{bannerAd.cta_url}}
              </span>
            </td>
            <td>
              <span class="banner-ad-table-categories">
                {{bannerAd.category_ids}}
              </span>
            </td>
            <td>
              <span class="banner-ad-table-groups">
                {{bannerAd.group_ids}}
              </span>
            </td>
            <td>
              <span class="banner-ad-table-enabled">
                {{#if bannerAd.enabled}}
                  {{icon "check"}}
                {{else}}
                  {{icon "xmark"}}
                {{/if}}
              </span>
            </td>
            <td>
              <div class="banner-ads-table-actions">
                <DButton
                  @action={{fn @setEditing bannerAd}}
                  @icon="pencil-alt"
                  class="edit-banner"
                />
                <DButton
                  @action={{fn @deleteBannerAd bannerAd}}
                  @icon="trash-alt"
                  class="delete-banner"
                />
              </div>
            </td>
          </tr>
        {{/each}}
      </tbody>
    </table>
  </div>
</template>;

export default BannerTable;
