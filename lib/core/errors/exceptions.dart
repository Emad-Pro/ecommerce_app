import 'package:ecommerce_app/core/errors/model/error_message_model.dart';

/// Base class for all server-side exceptions
class ServerException implements Exception {
  final ErorrMessageModel erorrMessageModel;
  ServerException({required this.erorrMessageModel});
}

/// Exception for cache/local issues
class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Unauthorized"]);
}
