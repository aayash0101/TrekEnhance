import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Print full debug info
    print('🔥 Dio error caught:');
    print('Type: ${err.type}');
    print('Message: ${err.message}');
    print('Response data: ${err.response?.data}');
    print('Status code: ${err.response?.statusCode}');
    print('Request: ${err.requestOptions.uri}');

    String errorMessage;

    if (err.response != null) {
      final statusCode = err.response?.statusCode ?? 0;
      if (statusCode >= 300) {
        errorMessage =
            err.response?.data['message']?.toString() ??
            err.response?.statusMessage ??
            'Unknown error';
      } else {
        errorMessage = 'Something went wrong';
      }
    } else {
      errorMessage = 'Connection error';
    }

    // Wrap & pass the error
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: errorMessage, // friendly message for UI
      type: err.type,
    );

    handler.next(customError);
  }
}
