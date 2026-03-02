import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';

import 'model/error_message_model.dart';

class ErrorHandler {
  final String message;
  final int? code;
  final bool? isVerfied;

  final Map<String, List<String>>? fieldErrors;

  ErrorHandler._(this.message, {this.code, this.fieldErrors, this.isVerfied});

  factory ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is ServerException) {
      final model = error.erorrMessageModel;
      return ErrorHandler._(model.statusMessage, code: model.statusCode, isVerfied: model.isVerfiedPhone);
    } else if (error is ErrorHandler) {
      return ErrorHandler._(
        error.message,
        code: error.code,
        fieldErrors: error.fieldErrors,
        isVerfied: error.isVerfied,
      );
    } else {
      return ErrorHandler._(error.toString(), code: -1);
    }
  }

  static Map<String, List<String>> _parseFieldErrors(dynamic errorsRaw) {
    final Map<String, List<String>> out = {};

    if (errorsRaw is Map) {
      for (final entry in errorsRaw.entries) {
        final key = entry.key.toString();
        final v = entry.value;

        if (v is List) {
          out[key] = v.map((e) => e.toString()).toList();
        } else if (v is String) {
          out[key] = [v];
        } else if (v != null) {
          out[key] = [v.toString()];
        }
      }
    }

    return out;
  }

  static ErrorHandler _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final statusMessage = response?.statusMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ErrorHandler._("Connection timeout", code: 408);

      case DioExceptionType.sendTimeout:
        return ErrorHandler._("Send timeout", code: 408);

      case DioExceptionType.receiveTimeout:
        return ErrorHandler._("Receive timeout", code: 408);

      case DioExceptionType.cancel:
        return ErrorHandler._("Request cancelled by user", code: 499);

      case DioExceptionType.badCertificate:
        return ErrorHandler._("Bad SSL certificate. Please check server security.", code: 495);

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return ErrorHandler._("No Internet connection", code: 0);
        }
        return ErrorHandler._("Connection error", code: 525);

      case DioExceptionType.badResponse:
        try {
          final raw = response?.data;

          if (raw is! Map) {
            final model = ErorrMessageModel.fromJson(raw);
            print("Model IS ${model}");
            return ErrorHandler._(
              statusMessage ?? "Unexpected server response",
              code: statusCode ?? 500,
              isVerfied: model.isVerfiedPhone,
            );
          }

          final safeMap = Map<String, dynamic>.from(raw);

          final errorsRaw = safeMap['errors'];
          if (errorsRaw is Map) {
            final fieldErrors = _parseFieldErrors(errorsRaw);

            String msg = (safeMap['title']?.toString().trim().isNotEmpty ?? false)
                ? safeMap['title'].toString()
                : (statusMessage ?? "Validation error");

            if (fieldErrors.isNotEmpty) {
              final firstKey = fieldErrors.keys.first;
              final firstMsg = fieldErrors[firstKey]?.isNotEmpty == true ? fieldErrors[firstKey]!.first : null;
              if (firstMsg != null && firstMsg.trim().isNotEmpty) {
                msg = firstMsg;
              }
            }
            final model = ErorrMessageModel.fromJson(safeMap);

            return ErrorHandler._(
              isVerfied: model.isVerfiedPhone,
              msg,
              code: statusCode ?? (safeMap['status'] as int?) ?? 400,
              fieldErrors: fieldErrors,
            );
          }

          final model = ErorrMessageModel.fromJson(safeMap);
          final code = model.statusCode != 0 ? model.statusCode : (statusCode ?? 500);

          return ErrorHandler._(
            model.statusMessage.isNotEmpty ? model.statusMessage : (statusMessage ?? "Unknown server error"),
            code: code,
            isVerfied: model.isVerfiedPhone,
          );
        } catch (_) {
          return ErrorHandler._(statusMessage ?? "Unexpected server response", code: statusCode ?? 500);
        }

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ErrorHandler._("No Internet connection", code: 0);
        }
        return ErrorHandler._("Unknown network error", code: 520);
    }
  }

  @override
  String toString() => 'ErrorHandler(message: $message, code: $code)';
}
