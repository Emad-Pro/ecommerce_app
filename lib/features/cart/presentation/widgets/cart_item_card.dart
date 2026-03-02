import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/depandcy_injection.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: colorScheme.surfaceContainerHighest.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.surfaceContainerHighest.withOpacity(0.2)),
            ),
            child: Image.network(product.image ?? '', fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.title ?? 'بدون اسم',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price ?? 0.0}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: colorScheme.primary),
                ),
              ],
            ),
          ),

          Column(
            children: [
              _buildQuantityButton(context, Icons.add_rounded, () {
                sl<CartBloc>().add(IncrementCartItemEvent(item));
              }),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              _buildQuantityButton(context, item.quantity == 1 ? Icons.delete_rounded : Icons.remove_rounded, () {
                if (item.quantity == 1) {
                  sl<CartBloc>().add(RemoveItemFromCartEvent(item.product.id!));
                }
                sl<CartBloc>().add(DecrementCartItemEvent(item.product.id!));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withOpacity(0.4), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: colorScheme.onSurface),
      ),
    );
  }
}
