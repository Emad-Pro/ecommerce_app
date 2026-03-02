import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/products_event.dart';

import '../../../../core/di/depandcy_injection.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => sl<ProductsBloc>().add(SearchProductsEvent(value)),
        decoration: InputDecoration(
          hintText: 'عن ماذا تبحث؟',
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: colorScheme.primary),
        ),
      ),
    );
  }
}
