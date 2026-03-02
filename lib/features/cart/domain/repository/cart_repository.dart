import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, Unit>> addToCart(CartItemEntity item);
  Future<Either<Failure, Unit>> removeFromCart(int productId);
  Future<Either<Failure, Unit>> decrementCartItem(int productId);
  Future<Either<Failure, Unit>> clearCart();
}
