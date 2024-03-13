import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/utils/shared_preference_util.dart';

class ApiState {
  String? _token;
  DateTime? _lastNotify;

  // Singleton
  static final ApiState _instance = ApiState._internal();

  factory ApiState() => _instance;

  ApiState._internal();

  // init
  Future<void> init() async {
    _token = await SharedPreferenceUtil().getData('token');
  }

  get isLogin => _token != null;

  get isNotLogin => _token == null;

  get tokenValue => _token;

  void updateToken(String token) {
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
