import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio {
    final dio = Dio();

    // No special configuration needed for different platforms
    // Dio will use the appropriate adapter automatically

    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    );

    // Add logging in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ));
    }

    return dio;
  }
}
