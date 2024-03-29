# frozen_string_literal: true

module PageObjects
  module Pages
    class AdminGroupCategoryBannerAds < PageObjects::Pages::Base
      def new_banner_btn
        ".btn.create-banner"
      end

      def save_banner
        find(".btn.save-banner").click
      end

      def reset_banner
        find(".btn.reset-banner").click
      end

      def click_new_banner_btn
        find(new_banner_btn).click
      end

      def banner_title
        find(".banner-title")
      end

      def banner_text
        find(".banner-text")
      end

      def banner_cta_url
        find(".banner-cta-url")
      end

      def edit_first_banner
        find(".btn.edit-banner").click
      end

      def delete_first_banner
        find(".btn.delete-banner").click
      end

      def first_banner_table_title
        ".banner-ad-table-title"
      end

      def first_banner_table_cta_url
        ".banner-ad-table-cta-url"
      end

      def first_banner_table_categories
        ".banner-ad-table-categories"
      end

      def first_banner_table_groups
        ".banner-ad-table-groups"
      end
    end
  end
end
