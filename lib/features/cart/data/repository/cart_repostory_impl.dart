import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/error_handler.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/errors/server_failure.dart';
import 'package:ecommerce_app/features/cart/data/data_source/cart_local_data_source.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../model/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في جلب السلة')));
    }
  }

  @override
  Future<Either<Failure, Unit>> addToCart(CartItemEntity item) async {
    try {
      final model = CartItemModel(product: item.product, quantity: item.quantity);
      await localDataSource.addToCart(model);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في الإضافة للسلة')));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(int productId) async {
    try {
      await localDataSource.removeFromCart(productId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في الحذف من السلة')));
    }
  }

  @override
  Future<Either<Failure, Unit>> decrementCartItem(int productId) async {
    try {
      await localDataSource.decrementCartItem(productId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في تقليل كمية المنتج')));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في تفريغ السله')));
    }
  }
}
