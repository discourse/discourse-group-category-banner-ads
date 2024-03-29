# frozen_string_literal: true

RSpec.describe "Admin - Discourse Group Category Banner Ads", type: :system, js: true do
  fab!(:current_user) { Fabricate(:admin) }
  let(:admin_banner_ad_page) { PageObjects::Pages::AdminGroupCategoryBannerAds.new }
  let(:title) { "New banner title" }
  let(:edited_title) { "New banner title - Edited" }
  let(:text) { "New banner text" }
  let(:cta_url) { "https://www.google.com" }
  fab!(:category) { Fabricate(:category) }
  fab!(:category2) { Fabricate(:category) }
  let(:category_id_1) { category.id }
  let(:category_id_2) { category2.id }
  fab!(:group) { Fabricate(:group) }
  fab!(:group2) { Fabricate(:group) }
  let(:group_id_1) { group.id }
  let(:group_id_2) { group2.id }

  before do
    SiteSetting.discourse_group_category_banner_ads_enabled = true
    sign_in(current_user)
    visit "/admin/plugins/group_category_banner_ads"
  end

  context "when visiting admin page" do
    it "displays a button to add a new banner ad" do
      expect(admin_banner_ad_page).to have_css(admin_banner_ad_page.new_banner_btn)
    end

    it "requires banner title" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_text.fill_in(with: text)
      admin_banner_ad_page.save_banner
      expect(admin_banner_ad_page).to have_content("Title is required!")
    end

    it "requires banner text" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_title.fill_in(with: title)
      admin_banner_ad_page.save_banner
      expect(admin_banner_ad_page).to have_content("Banner text is required!")
    end

    it "allows admin to save banner ad" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_title.fill_in(with: title)
      admin_banner_ad_page.banner_text.fill_in(with: text)
      admin_banner_ad_page.banner_cta_url.fill_in(with: cta_url)
      category_select_kit = PageObjects::Components::SelectKit.new(".banner-categories")
      category_select_kit.expand
      category_select_kit.select_row_by_value(category_id_1)
      category_select_kit.select_row_by_value(category_id_2)

      group_select_kit = PageObjects::Components::SelectKit.new(".banner-groups")
      group_select_kit.expand
      group_select_kit.select_row_by_value(group_id_1)
      group_select_kit.select_row_by_value(group_id_2)
      group_select_kit.collapse
      admin_banner_ad_page.save_banner

      expect(admin_banner_ad_page).to have_content("Banner ad created successfully!")
      expect(admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_title)).to have_text(
        title,
      )
      expect(
        admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_cta_url),
      ).to have_text(cta_url)
      expect(
        admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_categories),
      ).to have_text("#{category_id_1},#{category_id_2}")
      expect(
        admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_groups),
      ).to have_text("#{group_id_1},#{group_id_2}")
    end

    it "allows admin to cancel banner ad creation" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_title.fill_in(with: title)
      admin_banner_ad_page.reset_banner
      admin_banner_ad_page.click_new_banner_btn
      expect(admin_banner_ad_page.banner_title).not_to have_text(title)
    end

    it "allows admin to delete a banner ad" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_title.fill_in(with: title)
      admin_banner_ad_page.banner_text.fill_in(with: text)
      admin_banner_ad_page.save_banner

      expect(admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_title)).to have_text(
        title,
      )
      admin_banner_ad_page.delete_first_banner
      expect(admin_banner_ad_page).to have_content("Banner ad deleted successfully!")
      expect(admin_banner_ad_page).not_to have_css(admin_banner_ad_page.first_banner_table_title)
    end

    it "allows admin to edit a banner ad" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_title.fill_in(with: title)
      admin_banner_ad_page.banner_text.fill_in(with: text)
      admin_banner_ad_page.save_banner
      expect(admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_title)).to have_text(
        title,
      )

      admin_banner_ad_page.edit_first_banner
      admin_banner_ad_page.banner_title.fill_in(with: edited_title)
      admin_banner_ad_page.save_banner
      expect(admin_banner_ad_page).to have_content("Banner ad updated successfully!")
      expect(admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_title)).to have_text(
        edited_title,
      )
    end

    it "allows admin to cancel banner ad edits" do
      admin_banner_ad_page.click_new_banner_btn
      admin_banner_ad_page.banner_title.fill_in(with: title)
      admin_banner_ad_page.banner_text.fill_in(with: text)
      admin_banner_ad_page.save_banner

      admin_banner_ad_page.edit_first_banner
      admin_banner_ad_page.banner_title.fill_in(with: edited_title)
      admin_banner_ad_page.reset_banner
      expect(admin_banner_ad_page.find(admin_banner_ad_page.first_banner_table_title)).to have_text(
        title,
      )

      admin_banner_ad_page.click_new_banner_btn
      expect(admin_banner_ad_page.banner_title).not_to have_text(edited_title)
    end
  end
end
