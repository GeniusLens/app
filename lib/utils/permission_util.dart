import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static List<Permission> get permissions => [
        Permission.photos,
        Permission.storage,
      ];
  static Future<PermissionStatus> requestPermission(
      Permission permission) async {
    if (!permissions.contains(permission)) {
      throw ArgumentError('permission not found');
    }
    return await permission.request();
  }
}
