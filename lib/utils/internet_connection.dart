import 'dart:io';

import 'package:flutter/material.dart';

/// [InternetConnection]
/// to check the internet connection before calling any network call

class InternetConnection {
  static Future<bool> check() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}