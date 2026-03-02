import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  Future<Either<Failure, Unit>> call(CartItemEntity item) async {
    return await repository.addToCart(item);
  }
}
