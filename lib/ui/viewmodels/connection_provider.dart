import 'dart:async';

import 'package:attappv1/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _connectedToInternet = false;
  bool _connectedToServer = false;
  StreamSubscription? _internetConnectionStreamSubscription;
  Timer? _serverConnectionTimer;

  bool get connectedToInternet => _connectedToInternet;
  bool get connectedToServer => _connectedToServer;

  ConnectionProvider(){
    monitorInternetConnectivity();
    monitorServerConnectivity();
  }

  void monitorInternetConnectivity(){
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          _connectedToInternet = true;
          notifyListeners();
          break;
        case InternetStatus.disconnected:
          _connectedToInternet = false;
          notifyListeners();
          break;
      }
    });
  }

  void monitorServerConnectivity(){
    final serverConnection = InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(
          uri: Uri.parse('$baseUrl/ping')
        )
      ]
    );

     _serverConnectionTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      _connectedToServer = await serverConnection.hasInternetAccess;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    _serverConnectionTimer?.cancel();
    super.dispose();
  }
}