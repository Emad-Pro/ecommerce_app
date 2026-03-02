import 'package:ecommerce_app/core/constants/api_const.dart';
import 'package:ecommerce_app/core/errors/model/error_message_model.dart';
import 'package:ecommerce_app/core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioService dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(url: ApiConst.products);

      if (response != null && response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          erorrMessageModel: ErorrMessageModel(
            statusCode: response?.statusCode ?? 0,
            statusMessage: 'فشل في جلب المنتجات من الخادم',
            success: false,
          ),
        );
      }
    } catch (e) {
      throw ServerException(
        erorrMessageModel: ErorrMessageModel(statusCode: 0, statusMessage: 'حدث خطأ غير متوقع: $e', success: false),
      );
    }
  }
}
