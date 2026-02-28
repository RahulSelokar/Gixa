import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GlobalErrorController extends GetxController {

  bool hasError = false;
  bool isNetworkError = false;
  String errorMessage = "";

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  bool _appReady = false;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isClosed) {
        _appReady = true;
        _listenToConnectionChanges();
      }
    });
  }

  void _listenToConnectionChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {

      if (!_appReady || isClosed) return;

      if (result == ConnectivityResult.none) {
        _safeUpdate(() {
          hasError = true;
          isNetworkError = true;
          errorMessage = "No Internet Connection";
        });
      } else {
        _safeUpdate(() {
          hasError = false;
          isNetworkError = false;
          errorMessage = "";
        });
      }
    });
  }

  void showNetworkError() {
    if (isClosed) return;

    _safeUpdate(() {
      hasError = true;
      isNetworkError = true;
      errorMessage = "No Internet Connection";
    });
  }

  void showServerError() {
    if (isClosed) return;

    _safeUpdate(() {
      hasError = true;
      isNetworkError = false;
      errorMessage = "Server error. Please try again later.";
    });
  }

  void hideError() {
    if (isClosed) return;

    _safeUpdate(() {
      hasError = false;
      isNetworkError = false;
      errorMessage = "";
    });
  }

  void _safeUpdate(VoidCallback fn) {
    if (!isClosed) {
      fn();
      update();
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _subscription = null;
    super.onClose();
  }
}