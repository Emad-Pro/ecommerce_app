import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/error_handler.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository_impl.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/server_failure.dart';
import '../../domain/entities/products_enities.dart';

import '../data_sources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl(this.productRemoteDataSource);

  @override
  Future<Either<Failure, List<ProductsEnities>>> fetchProducts() async {
    try {
      final remoteProducts = await productRemoteDataSource.getProducts();

      return Right(remoteProducts);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle(e)));
    }
  }
}
