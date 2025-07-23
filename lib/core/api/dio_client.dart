import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio getDioClient() {
  final dio = Dio();

  if (kIsWeb) {
    // Use BrowserHttpClientAdapter for web platform
    dio.httpClientAdapter = BrowserHttpClientAdapter();
  }

  // For other platforms, Dio will use the default HttpClientAdapter.

  return dio;
}
