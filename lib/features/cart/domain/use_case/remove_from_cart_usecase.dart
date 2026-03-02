import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int productId) async {
    return await repository.removeFromCart(productId);
  }
}
