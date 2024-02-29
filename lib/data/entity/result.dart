
class Result<T> {
  final String code;
  final String msg;
  final T data;

  Result(this.code, this.msg, this.data);

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      json['code'],
      json['msg'],
      json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}