import 'package:dio/dio.dart';
import 'package:family_bazar_admin_panel/src/core/const/app_strings.dart';

class NetworkExceptions implements Exception {
  final String message;
  final int? statusCode;

  NetworkExceptions({required this.message, this.statusCode});

  /// Factory constructor to parse standard DioExceptions
  factory NetworkExceptions.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return NetworkExceptions(message: AppStrings.msg499, statusCode: 499);
      case DioExceptionType.connectionTimeout:
        return NetworkExceptions(message: AppStrings.connectionTimeout, statusCode: 408);
      case DioExceptionType.receiveTimeout:
        return NetworkExceptions(message: AppStrings.receiveTimeout, statusCode: 408);
      case DioExceptionType.sendTimeout:
        return NetworkExceptions(message: AppStrings.sendTimeout, statusCode: 408);
      case DioExceptionType.badResponse:
        return NetworkExceptions(
          message: _handleStatusError(
            dioException.response?.statusCode,
            dioException.response?.data,
          ),
          statusCode: dioException.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return NetworkExceptions(message: AppStrings.noInternet, statusCode: 503);
      case DioExceptionType.unknown:
        return NetworkExceptions(message: AppStrings.unexpectedError, statusCode: 500);
      default:
        return NetworkExceptions(message: AppStrings.somethingWentWrong, statusCode: 500);
    }
  }

  /// Parses specific HTTP Status Codes
  static String _handleStatusError(int? statusCode, dynamic errorData) {
    // Attempt to extract the exact error message sent by the backend developer
    if (errorData is Map<String, dynamic> && errorData.containsKey("message")) {
      return errorData["message"].toString();
    }

    // Fallbacks if backend doesn't provide a custom message
    switch (statusCode) {
      case 400: return AppStrings.msg400;
      case 401: return AppStrings.msg401;
      case 403: return AppStrings.msg403;
      case 404: return AppStrings.msg404;
      case 405: return AppStrings.msg405;
      case 406: return AppStrings.msg406;
      case 408: return AppStrings.msg408;
      case 409: return AppStrings.msg409;
      case 413: return AppStrings.msg413;
      case 415: return AppStrings.msg415;
      case 422: return AppStrings.msg422;
      case 429: return AppStrings.msg429;
      case 500: return AppStrings.msg500;
      case 502: return AppStrings.msg502;
      case 503: return AppStrings.msg503;
      case 504: return AppStrings.msg504;
      case 522: return AppStrings.msg522;
      default: return '${AppStrings.errorMsgDefault}: $statusCode';
    }
  }

  @override
  String toString() => message;
}