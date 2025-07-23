import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkService {
  Future<bool> isConnected();
  Stream<bool> get connectivityStream;
}

@Injectable(as: NetworkService)
class NetworkServiceImpl implements NetworkService {
  @override
  Future<bool> isConnected() async {
    if (kIsWeb) {
      print(
          "NetworkService: Web platform detected, assuming connection is available.");
      return true; // Assume connected on web
    }
    try {
      print("NetworkService: Checking native platform connection...");
      final result = await InternetAddress.lookup('google.com');
      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      print("NetworkService: Native connection status: $connected");
      return connected;
    } on SocketException catch (_) {
      print(
          "NetworkService: Native connection check failed (SocketException).");
      return false;
    }
  }

  @override
  Stream<bool> get connectivityStream async* {
    if (kIsWeb) {
      yield true; // On web, yield true once and complete.
      return;
    }
    while (true) {
      yield await isConnected();
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
