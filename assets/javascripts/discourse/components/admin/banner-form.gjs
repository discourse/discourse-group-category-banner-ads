import { fn, hash } from "@ember/helper";
import { on } from "@ember/modifier";
import DButton from "discourse/components/d-button";
import i18n from "discourse-common/helpers/i18n";
import GroupChooser from "select-kit/components/group-chooser";
import or from "truth-helpers/helpers/or";
import BannerAdCategorySelector from "../banner-ad-category-selector";

const BannerForm = <template>
  <div class="new-banner-ad">
    {{#if (or @creating @editing)}}
      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.title.label"}}
        </span>
        <span class="banner-ad-value">
          <input
            type="text"
            {{on "change" @setBannerTitle}}
            value={{@bannerAd.title}}
            placeholder={{i18n
              "discourse_group_category_banner_ads.title.placeholder"
            }}
            class="banner-title"
          />
        </span>
      </div>

      <br />

      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.banner_text.label"}}
        </span>
        <span class="banner-ad-value">
          <textarea
            type="text"
            {{on "change" @setBannerText}}
            placeholder={{i18n
              "discourse_group_category_banner_ads.banner_text.description"
            }}
            value={{@bannerAd.banner_text}}
            class="banner-text"
          />
        </span>
      </div>

      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.cta_url.label"}}
        </span>
        <span class="banner-ad-value">
          <input
            type="text"
            {{on "change" @setCtaUrl}}
            placeholder={{i18n
              "discourse_group_category_banner_ads.cta_url.description"
            }}
            value={{@bannerAd.cta_url}}
            class="banner-cta-url"
          />
        </span>
      </div>

      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.cta_text.label"}}
        </span>
        <span class="banner-ad-value">
          <input
            type="text"
            {{on "change" @setCtaText}}
            placeholder={{i18n
              "discourse_group_category_banner_ads.cta_text.description"
            }}
            value={{@bannerAd.cta_text}}
            class="banner-cta-text"
          />
        </span>
      </div>

      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.category_ids.label"}}
        </span>
        <span class="banner-ad-value">
          <BannerAdCategorySelector
            @categories={{@categories}}
            @selectedCategories={{@selectedCategories}}
            @onChange={{@setCategoryIds}}
            @options={{hash allowAny=true}}
            class="banner-categories"
          />
          <div class="banner-ad-description">
            {{i18n
              "discourse_group_category_banner_ads.category_ids.description"
            }}
          </div>
        </span>
      </div>

      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.group_ids.label"}}
        </span>
        <span class="banner-ad-value">
          <GroupChooser
            @content={{@groups}}
            @onChange={{@setGroupIds}}
            @value={{@selectedGroups}}
            class="banner-groups"
          />
          <div class="banner-ad-description">
            {{i18n "discourse_group_category_banner_ads.group_ids.description"}}
          </div>
        </span>
      </div>

      <div class="banner-field">
        <span class="banner-ad-label">
          {{i18n "discourse_group_category_banner_ads.enabled.label"}}
        </span>
        <span class="banner-ad-value">
          <div class="banner-ad-description">
            <input
              type="checkbox"
              {{on "change" @setEnabled}}
              checked={{@bannerAd.enabled}}
              class="banner-enabled"
            />
            {{i18n "discourse_group_category_banner_ads.enabled.description"}}
          </div>
        </span>
      </div>

      <div>
        <DButton
          @action={{fn @saveBannerAd @bannerAd}}
          @label="discourse_group_category_banner_ads.admin.save_new_banner_ad"
          class="save-banner"
        />
        <DButton
          @action={{@reset}}
          @label="discourse_group_category_banner_ads.admin.cancel_new_banner_ad"
          class="reset-banner"
        />
      </div>
    {{else}}
      <DButton
        @action={{@setCreating}}
        @label="discourse_group_category_banner_ads.admin.new_banner_ad"
        class="create-banner"
      />
    {{/if}}
  </div>
</template>;

export default BannerForm;
