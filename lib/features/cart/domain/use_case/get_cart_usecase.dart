import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';

import '../entities/cart_item_entity.dart';

class GetCartItemsUseCase {
  final CartRepository repository;
  GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    return await repository.getCartItems();
  }
}
