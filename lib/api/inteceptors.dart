import 'package:dio/dio.dart';
import 'package:genius_lens/api/state.dart';
import 'package:genius_lens/router.dart';
import 'package:genius_lens/utils/package_util.dart';
import 'package:get/get.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ApiState().isLogin) {
      options.headers['Authorization'] = 'Bearer ${ApiState().tokenValue}';
    }
    super.onRequest(options, handler);
  }
}

class VersionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Version'] = PackageUtil().version;
    super.onRequest(options, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  // 现在的时间减去一分钟
  DateTime _lastRoute = DateTime.now().subtract(const Duration(minutes: 1));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.badResponse:
        _handleBadResponse(err);
        break;
      default:
    }
    super.onError(err, handler);
  }

  void _handleBadResponse(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        ApiState().notify('请先登录');
        if (DateTime.now().difference(_lastRoute) >
            const Duration(seconds: 1)) {
          Get.offAllNamed(AppRouter.login);
          _lastRoute = DateTime.now();
        }
        break;
      case 403:
        ApiState().notify('请联系管理员');
        break;
      case 404:
        ApiState().notify('资源不存在, 请稍后重试');
        break;
      case 500 || 502:
        ApiState().notify('服务器错误, 请稍后重试');
        break;
      default:
        ApiState().notify('网络错误, 请稍后重试');
    }
  }
}
