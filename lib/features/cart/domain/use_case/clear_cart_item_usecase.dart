import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repository/cart_repository.dart';

class ClearCartItemUseCase {
  final CartRepository repository;
  ClearCartItemUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearCart();
  }
}
