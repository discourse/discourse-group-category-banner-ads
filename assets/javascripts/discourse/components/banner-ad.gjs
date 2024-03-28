import concatClass from "discourse/helpers/concat-class";
import { dasherize } from "@ember/string";
import { htmlSafe } from "@ember/template";

const BannerAd = <template>
  <div
    class={{concatClass (dasherize @banner.title) "group-category-banner-ad"}}
  >
    <span class="group-category-banner-ad-text">
      {{htmlSafe @banner.banner_text}}
    </span>
    <a href={{@banner.cta_url}} class="btn btn-default">
      <span class="group-category-banner-ad-cta-text">
        {{@banner.cta_text}}
      </span>
    </a>
  </div>
</template>;

export default BannerAd;
