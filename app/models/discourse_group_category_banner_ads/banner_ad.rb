# frozen_string_literal: true

class DiscourseGroupCategoryBannerAds::BannerAd < ::ActiveRecord::Base
  self.table_name = "banner_ads"
end

# == Schema Information
#
# Table name: banner_ads
#
#  id           :bigint           not null, primary key
#  title        :string           default(""), not null
#  cta_url      :string(2048)
#  cta_text     :string           default("")
#  banner_text  :string           default(""), not null
#  category_ids :integer          default([]), is an Array
#  group_ids    :integer          default([]), is an Array
#  enabled      :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
