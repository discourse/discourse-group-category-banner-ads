import CategorySelector from "discourse/select-kit/components/category-selector";

export default class BannerAdCategorySelector extends CategorySelector {
  get value() {
    return this.selectedCategories.map((c) => c.id);
  }
}
