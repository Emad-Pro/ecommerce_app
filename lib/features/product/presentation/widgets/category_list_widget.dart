import 'package:flutter/material.dart';

import '../../../../core/di/depandcy_injection.dart';
import '../../../../core/states/request_state.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  String _translateCategory(String category) {
    switch (category) {
      case "electronics":
        return "إلكترونيات";
      case "jewelery":
        return "مجوهرات";
      case "men's clothing":
        return "ملابس رجالي";
      case "women's clothing":
        return "ملابس نسائي";
      case "الكل":
        return "الكل";
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ProductsBloc, ProductsState>(
      bloc: sl<ProductsBloc>(),
      builder: (context, state) {
        if (state.categories.isEmpty && state.productsState == AppRequestState.loading) {
          return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
        }

        final displayCategories = ['الكل', ...state.categories];

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final category = displayCategories[index];
              final isSelected = category == state.selectedCategory;

              return GestureDetector(
                onTap: () {
                  sl<ProductsBloc>().add(SelectCategoryEvent(category));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _translateCategory(category),
                    style: TextStyle(
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
