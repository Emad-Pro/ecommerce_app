import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';

class CheckoutBottomBar extends StatelessWidget {
  final List<CartItemEntity> cartItems;

  const CheckoutBottomBar({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    double totalPrice = cartItems.fold(0, (sum, item) {
      return sum + ((item.product.price ?? 0.0) * item.quantity);
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الإجمالي:',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                  Text(
                    totalPrice.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 24),

          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                shadowColor: colorScheme.primary.withOpacity(0.3),
              ),
              child: const Text(
                'إتمام الطلب',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
