import 'package:ecommerce_app/core/states/request_state.dart';

import '../../domain/entities/products_enities.dart';
import 'package:equatable/equatable.dart';

class ProductsState extends Equatable {
  final AppRequestState productsState;

  final List<ProductsEnities> allProducts;

  final List<ProductsEnities> filteredProducts;

  final List<String> categories;

  final String selectedCategory;

  final String searchQuery;

  final String? message;

  ProductsState({
    this.productsState = AppRequestState.loading,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.selectedCategory = 'الكل',
    this.searchQuery = '',
    this.message,
  });

  ProductsState copyWith({
    AppRequestState? productsState,
    List<ProductsEnities>? allProducts,
    List<ProductsEnities>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    String? message,
  }) {
    return ProductsState(
      productsState: productsState ?? this.productsState,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    productsState,
    allProducts,
    filteredProducts,
    categories,
    selectedCategory,
    searchQuery,
    message,
  ];
}
