import 'dart:async';
import 'package:attappv1/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _connectedToServer = true;
  Timer? _retryTimer;

  bool get connectedToServer => _connectedToServer;

  /// Call this from anywhere (API client or UI)
  Future<bool> checkServerOnce() async {
    try {
      final serverConnection = InternetConnection.createInstance(
        customCheckOptions: [
          InternetCheckOption(uri: Uri.parse('$baseUrl/ping')),
        ],
      );

      bool isOnline = await serverConnection.hasInternetAccess;

      if (isOnline) {
        _markOnline();
      } else {
        _markOffline();
      }

      return isOnline;
    } catch (e) {
      _markOffline();
      return false;
    }
  }

  void _markOffline() {
    if (_connectedToServer == true) {
      _connectedToServer = false;
      notifyListeners();
      _startRetry();
    }
  }

  void _markOnline() {
    if (_connectedToServer == false) {
      _connectedToServer = true;
      notifyListeners();
      _stopRetry();
    }
  }

  void _startRetry() {
    _retryTimer ??= Timer.periodic(
      const Duration(seconds: 12),
      (_) async {
        await checkServerOnce();
      },
    );
  }

  void _stopRetry() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }
}
