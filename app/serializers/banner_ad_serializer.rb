# frozen_string_literal: true

class BannerAdSerializer < ApplicationSerializer
  attributes :id, :created_at, :cta_url, :cta_text, :banner_text, :category_ids, :group_ids, :enabled

  has_many :categories, serializer: BasicCategorySerializer, embed: :objects
  has_many :groups, serializer: BasicGroupSerializer, embed: :objects

  def categories
    Category.secured(scope).where(id: object[:category_ids].split("|"))
  end

  def groups
    Group.secured(scope).where(id: object[:group_ids].split("|"))
  end

  def include_categories?
    object.category_ids.present?
  end

  def include_groups?
    object.group_ids.present?
  end
end
