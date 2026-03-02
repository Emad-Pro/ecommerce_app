import 'package:ecommerce_app/features/product/domain/entities/products_enities.dart';

class CartItemEntity {
  final ProductsEnities product;
  int quantity;

  CartItemEntity({required this.product, this.quantity = 1});
}
