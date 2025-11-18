import 'dart:async';
import 'dart:developer';
import 'package:attappv1/data/constants.dart';
import 'package:attappv1/main.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _connectedToServer = true;
  Timer? _retryTimer;
  DateTime? lastSuccessfulConnection;
  int serverRetryIntervalSeconds = 8;
  bool _wasOnline = true;
  final refreshNotifier = ValueNotifier<DateTime>(DateTime.now());

  bool get connectedToServer => _connectedToServer;

  /// Check server connectivity once (for initial check or manual retry)
  Future<void> checkServerOnce() async {
    if (lastSuccessfulConnection != null) {
      final difference = DateTime.now().difference(lastSuccessfulConnection!);
      if (difference.inSeconds < serverRetryIntervalSeconds) {
        log(
          "Skipping server check; last successful connection was $difference ago.",
        );
        return;
      }
    }
    _wasOnline = _connectedToServer;
    final connection = InternetConnection.createInstance(
      useDefaultOptions: false,
      customCheckOptions: [
        InternetCheckOption(
          uri: Uri.parse('$baseUrl/ping'),
          timeout: const Duration(seconds: 3),
          responseStatusFn: (response) => response.statusCode == 200,
        ),
      ],
    );
    bool ok = await connection.hasInternetAccess;
    if (ok) {
      lastSuccessfulConnection = DateTime.now();
      markOnline();
    } else {
      markOffline();
    }
  }

  void markOffline() {
    if (_connectedToServer) {
      _connectedToServer = false;
      notifyListeners();
      _startRetryTimer();

      log("Server connection lost.");
      _wasOnline = false;
    }
    log("Server still offline, will retry...");
  }

  void markOnline() {
    _connectedToServer = true;
    notifyListeners();
    _stopRetryTimer();

    if (!_wasOnline && _connectedToServer) {
      log("Server connection restored.");
      _showGlobalSnackbar("Server connection restored.", Colors.green);
      _refreshCurrentPage();
      _wasOnline = true;
    }
  }

  /// Retry loop: checks /ping every X seconds until server is back
  void _startRetryTimer() {
    if (_retryTimer != null) return;

    _retryTimer = Timer.periodic(const Duration(seconds: 8), (timer) async {
      await checkServerOnce();
    });
  }

  void _stopRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  @override
  void dispose() {
    _stopRetryTimer();
    super.dispose();
  }

  void _showGlobalSnackbar(String message, Color color) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _refreshCurrentPage() {
    refreshNotifier.value = DateTime.now();
  }
}
