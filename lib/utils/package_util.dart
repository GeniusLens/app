import 'package:package_info_plus/package_info_plus.dart';

class PackageUtil {
  PackageInfo? packageInfo;

  String? version;

  // 单例模式
  static final PackageUtil _instance = PackageUtil._internal();

  factory PackageUtil() => _instance;

  PackageUtil._internal() {
    if (packageInfo == null) {
      initialize();
    }
  }

  // 初始化
  initialize() async {
    packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo?.version;
  }
}
