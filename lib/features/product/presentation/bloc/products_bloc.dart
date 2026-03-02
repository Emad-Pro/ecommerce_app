import 'dart:async';

import 'package:ecommerce_app/core/states/request_state.dart';
import 'package:ecommerce_app/features/product/domain/use_cases/get_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'products_event.dart';
import 'products_state.dart';

import '../../domain/entities/products_enities.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase}) : super(ProductsState()) {
    on<FetchProductsEvent>(_fetchInitialData);
    on<SearchProductsEvent>(_searchProducts);
    on<SelectCategoryEvent>(_selectCategory);
  }

  FutureOr<void> _fetchInitialData(FetchProductsEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(productsState: AppRequestState.loading));

    final failureOrProducts = await getProductsUseCase.call();

    failureOrProducts.fold(
      (failure) {
        emit(state.copyWith(productsState: AppRequestState.failure, message: failure.message));
      },
      (products) {
        final extractedCategories = products.where((p) => p.category != null).map((p) => p.category!).toSet().toList();

        emit(
          state.copyWith(
            productsState: AppRequestState.success,
            allProducts: products,
            filteredProducts: products,
            categories: extractedCategories,
            selectedCategory: 'الكل',
          ),
        );
      },
    );
  }

  void _applyFilters(Emitter<ProductsState> emit, String category, String query) {
    List<ProductsEnities> result = state.allProducts;

    if (category != 'الكل') {
      result = result.where((p) => p.category == category).toList();
    }

    if (query.isNotEmpty) {
      result = result.where((p) => (p.title ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    }

    emit(state.copyWith(filteredProducts: result, selectedCategory: category, searchQuery: query));
  }

  FutureOr<void> _searchProducts(SearchProductsEvent event, Emitter<ProductsState> emit) {
    _applyFilters(emit, state.selectedCategory, event.query);
  }

  FutureOr<void> _selectCategory(SelectCategoryEvent event, Emitter<ProductsState> emit) {
    _applyFilters(emit, event.category, state.searchQuery);
  }
}
