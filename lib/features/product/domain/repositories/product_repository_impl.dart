import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/product/domain/entities/products_enities.dart';
import "package:dartz/dartz.dart";

abstract class ProductRepository {
  Future<Either<Failure, List<ProductsEnities>>> fetchProducts();
}
