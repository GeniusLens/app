import 'package:dio/dio.dart';

class HttpUtil {
  static const String baseUrl = 'https://genius-lens.thuray.xyz';
  // static const String baseUrl = 'http://10.10.10.206:10086';

  // 构造Dio单例
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ),
  )..interceptors.add(
      LogInterceptor(responseBody: true),
    );

  // 公共请求头，支持添加新的请求头
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzA5MjMyMzA0LCJleHAiOjE3MDkzMTg3MDR9.n0sW7dO4ZoZFPjVrQBn05m2hlzC5tCnAEkJWMmN9aS8',
  };

  // 添加请求头
  static void addHeader(String key, String value) {
    _headers[key] = value;
  }

  // 移除请求头
  static void removeHeader(String key) {
    _headers.remove(key);
  }

  // GET请求
  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: Options(headers: _headers),
    );
  }

  // POST请求
  static Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: _headers),
    );
  }

  // DELETE请求
  static Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: _headers),
    );
  }

  // PUT请求
  static Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: _headers),
    );
  }
}
