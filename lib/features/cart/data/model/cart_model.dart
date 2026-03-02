import '../../domain/entities/cart_item_entity.dart';

import '../../../product/data/models/product_model.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({required super.product, super.quantity = 1});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(product: ProductModel.fromJson(json['product']), quantity: json['quantity'] ?? 1);
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': product.image,
        'rating': product.rating != null ? {'rate': product.rating!.rate, 'count': product.rating!.count} : null,
      },
      'quantity': quantity,
    };
  }
}
