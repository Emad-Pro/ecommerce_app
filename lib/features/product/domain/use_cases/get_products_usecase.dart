import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/product/domain/entities/products_enities.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository_impl.dart';
import 'package:dartz/dartz.dart';

class GetProductsUseCase {
  final ProductRepository productRepository;
  GetProductsUseCase(this.productRepository);
  Future<Either<Failure, List<ProductsEnities>>> call() async => await productRepository.fetchProducts();
}
