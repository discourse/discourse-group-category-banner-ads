# frozen_string_literal: true

class CreateBannerAds < ActiveRecord::Migration[7.0]
  def change
    create_table :banner_ads do |t|
      t.string :title, null: false, default: ""
      t.string :cta_url, null: true, default: nil, limit: 2048
      t.string :cta_text, null: true, default: ""
      t.string :banner_text, null: false, default: ""
      t.integer :category_ids, array: true, null: false, default: []
      t.integer :group_ids, array: true, null: false, default: []
      t.boolean :enabled, null: false, default: false

      t.timestamps
    end
  end
end
