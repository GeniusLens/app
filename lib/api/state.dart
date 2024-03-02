import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApiState {
  String? _token;
  DateTime? _lastNotify;

  // Singleton
  static final ApiState _instance = ApiState._internal();

  factory ApiState() => _instance;

  ApiState._internal() {
    print('ApiState init');
  }

  get isLogin => _token != null;

  get isNotLogin => _token == null;

  get tokenValue => _token;

  void initialize() async {
    print('ApiState initialize');
  }

  void updateToken(String token) {
    print('ApiState updateToken: $token');
    _token = token;
  }

  void notify(
    String message, {
    Duration? duration,
    bool error = false,
  }) {
    if (_lastNotify != null &&
        DateTime.now().difference(_lastNotify!) < const Duration(seconds: 3)) {
      return;
    }

    if (error) {
      EasyLoading.showError(message,
          duration: duration ?? const Duration(seconds: 3), dismissOnTap: true);
    } else {
      EasyLoading.showInfo(message,
          duration: duration ?? const Duration(seconds: 3), dismissOnTap: true);
    }

    _lastNotify = DateTime.now();
  }

  @override
  String toString() {
    return 'ApiState{token: $_token}';
  }
}
