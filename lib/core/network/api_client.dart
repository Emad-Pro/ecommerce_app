import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../errors/error_handler.dart';
import '../errors/model/error_message_model.dart';

typedef UnauthorizedHandler = Future<void> Function();

class DioService {
  DioService() : this._internal();

  late final Dio _dio;

  final StreamController<int> _codeStreamController = StreamController<int>.broadcast();
  Stream<int> get codeStream => _codeStreamController.stream;

  DioService._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: false, responseBody: true, compact: true),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresAuth = (options.extra['requiresAuth'] == true);

          if (requiresAuth) {
            options.headers.remove('Authorization');
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final response = e.response;

          try {
            if (response?.data is Map<String, dynamic>) {
              final data = response!.data as Map<String, dynamic>;
              if (data['code'] == 4001 || data['code'] == '4001') {}
            }
          } catch (_) {}

          return handler.next(e);
        },
      ),
    ]);
  }

  Dio get client => _dio;

  Future<Response?> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: queryParameters,
        options: requiresAuth == false ? options : options ?? Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (_) {
      throw _unexpectedError();
    }
  }

  Future<Response?> post({required String url, dynamic data, bool requiresAuth = false, String? contentType}) async {
    try {
      return await _dio.post(
        url,
        data: data,
        options: Options(extra: {'requiresAuth': requiresAuth}, contentType: contentType),
      );
    } on DioException catch (e) {
      final err = ErrorHandler.handle(e);

      print("DIO ERROR => code: ${err.code}, message: ${err.message}");
      if (err.fieldErrors != null && err.fieldErrors!.isNotEmpty) {
        print("FIELD ERRORS => ${err.fieldErrors}");
      }

      throw err;
    } catch (e) {
      final err = ErrorHandler.handle(e);
      print("UNEXPECTED ERROR => ${err.message}");
      throw err;
    }
  }

  Future<Response?> delete({required String url, Map<String, dynamic>? data, bool requiresAuth = true}) async {
    try {
      return await _dio.delete(
        url,
        data: data,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (_) {
      throw _unexpectedError();
    }
  }

  Future<Response?> put({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      final err = ErrorHandler.handle(e);

      print("DIO PUT ERROR => code: ${err.code}, message: ${err.message}");
      if (err.fieldErrors != null && err.fieldErrors!.isNotEmpty) {
        print("FIELD ERRORS => ${err.fieldErrors}");
      }

      throw err;
    } catch (e) {
      final err = ErrorHandler.handle(e);
      print("UNEXPECTED PUT ERROR => ${err.message}");
      throw err;
    }
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = token;
  }

  void clearToken() => _dio.options.headers.remove('Authorization');

  ServerException _unexpectedError() => ServerException(
    erorrMessageModel: ErorrMessageModel(
      statusCode: -999,
      statusMessage: "Unexpected application error",
      success: false,
    ),
  );

  void dispose() {
    _codeStreamController.close();
  }
}
