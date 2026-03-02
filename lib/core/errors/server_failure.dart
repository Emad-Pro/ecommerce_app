import 'package:ecommerce_app/core/errors/error_handler.dart';
import 'package:ecommerce_app/core/errors/failures.dart';

class ServerFailure extends Failure {
  final ErrorHandler error;

  ServerFailure({required this.error}) : super(message: error.message, code: error.code);
}
