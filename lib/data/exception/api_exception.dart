
/// 解析请求数据失败异常
class ParseDataException implements Exception {
  final String message;

  ParseDataException(this.message);

  @override
  String toString() {
    return 'ParseDataException{message: $message}';
  }
}

/// 密码错误异常
class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException(this.message);

  @override
  String toString() {
    return 'WrongPasswordException{message: $message}';
  }
}