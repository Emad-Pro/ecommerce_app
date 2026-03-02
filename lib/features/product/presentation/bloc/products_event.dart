abstract class ProductsEvent {}

// إيفينت جلب المنتجات
class FetchProductsEvent extends ProductsEvent {}

class SearchProductsEvent extends ProductsEvent {
  final String query;
  SearchProductsEvent(this.query);
}

class SelectCategoryEvent extends ProductsEvent {
  final String category;
  SelectCategoryEvent(this.category);
}
