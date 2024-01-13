
/// 解析请求数据失败异常
class ParseDataException implements Exception {
  final String message;

  ParseDataException(this.message);

  @override
  String toString() {
    return 'ParseDataException{message: $message}';
  }
}