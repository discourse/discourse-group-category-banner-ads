# frozen_string_literal: true

RSpec.describe "Category - Discourse Group Category Banner Ads", type: :system, js: true do
  fab!(:user_in_valid_group) { Fabricate(:user, group_ids: [Group::AUTO_GROUPS[:trust_level_1]]) }
  fab!(:user_not_in_valid_group, :user)
  let(:title) { "New banner title" }
  let(:text) { "New banner text" }
  let(:updated_text) { "New banner text - Updated" }
  let(:cta_url) { "https://www.google.com/" }
  let(:cta_text) { "Click Me" }
  fab!(:valid_category, :category)
  fab!(:invalid_category, :category)

  before { SiteSetting.discourse_group_category_banner_ads_enabled = true }

  context "when ad enabled" do
    before do
      banner_ad =
        DiscourseGroupCategoryBannerAds::BannerAd.create!(
          title: title,
          banner_text: text,
          cta_url: cta_url,
          cta_text: cta_text,
          group_ids: [Group::AUTO_GROUPS[:trust_level_1]],
          category_ids: [valid_category.id],
          enabled: true,
        )
    end

    context "when visiting valid category" do
      it "displays banner ad to user with group membership" do
        sign_in(user_in_valid_group)
        visit "/c/#{valid_category.id}"
        expect(page).to have_css(".group-category-banner-ad")
        expect(page.find(".group-category-banner-ad-text")).to have_text(text)
        expect(page.find("a.group-category-banner-ad-cta-url")["href"]).to eq(cta_url)
        expect(page.find(".group-category-banner-ad-cta-text")).to have_text(cta_text)
      end

      it "updating banner ad updates ad for user" do
        sign_in(user_in_valid_group)
        visit "/c/#{valid_category.id}"
        expect(page).to have_css(".group-category-banner-ad")
        expect(page.find(".group-category-banner-ad-text")).to have_text(text)

        DiscourseGroupCategoryBannerAds::BannerAd.find_by(title: title).update!(
          banner_text: updated_text,
        )

        visit "/c/#{valid_category.id}"
        expect(page).to have_css(".group-category-banner-ad")
        expect(page.find(".group-category-banner-ad-text")).to have_text(updated_text)
      end

      it "displays banner ad to anon when no group_ids are set" do
        DiscourseGroupCategoryBannerAds::BannerAd.find_by(title: title).update!(group_ids: [])

        visit "/c/#{valid_category.id}"
        expect(page).to have_css(".group-category-banner-ad")
        expect(page.find(".group-category-banner-ad-text")).to have_text(text)
      end

      it "does not display banner ad to anon when no group membership" do
        visit "/c/#{valid_category.id}"
        expect(page).not_to have_css(".group-category-banner-ad")
      end

      it "displays display banner ad to user without group membership when 'everyone' group included" do
        DiscourseGroupCategoryBannerAds::BannerAd.find_by(title: title).update!(
          group_ids: [Group::AUTO_GROUPS[:trust_level_1], Group::AUTO_GROUPS[:everyone]],
        )

        sign_in(user_not_in_valid_group)
        visit "/c/#{valid_category.id}"
        expect(page).to have_css(".group-category-banner-ad")
      end

      it "does not display banner ad to user without group membership" do
        sign_in(user_not_in_valid_group)
        visit "/c/#{valid_category.id}"
        expect(page).not_to have_css(".group-category-banner-ad")
      end
    end

    context "when visiting invalid category" do
      it "does not display banner ad to user with group membership" do
        sign_in(user_in_valid_group)
        visit "/c/#{invalid_category.id}"
        expect(page).not_to have_css(".group-category-banner-ad")
      end
    end
  end

  context "when ad disabled" do
    before do
      DiscourseGroupCategoryBannerAds::BannerAd.create!(
        title: title,
        banner_text: text,
        group_ids: [Group::AUTO_GROUPS[:trust_level_1]],
        category_ids: [valid_category.id],
        enabled: false,
      )
    end

    context "when visiting valid category" do
      it "does not display banner ad to user with group membership" do
        sign_in(user_in_valid_group)
        visit "/c/#{valid_category.id}"
        expect(page).not_to have_css(".group-category-banner-ad")
      end
    end
  end
end
