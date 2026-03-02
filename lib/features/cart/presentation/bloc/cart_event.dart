import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartEvent {}

class GetCartEvent extends CartEvent {}

class AddItemToCartEvent extends CartEvent {
  final CartItemEntity item;
  AddItemToCartEvent(this.item);
}

class RemoveItemFromCartEvent extends CartEvent {
  final int productId;
  RemoveItemFromCartEvent(this.productId);
}

class DecrementCartItemEvent extends CartEvent {
  final int productId;
  DecrementCartItemEvent(this.productId);
}

class IncrementCartItemEvent extends CartEvent {
  final CartItemEntity item;
  IncrementCartItemEvent(this.item);
}

class ClearCartEvent extends CartEvent {}
