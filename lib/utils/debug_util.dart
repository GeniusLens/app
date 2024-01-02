import 'dart:math';

class DebugUtil {
  static String getRandomImageURL({
    int width = 200,
    int height = 300,
  }) {
    final random = Random();
    final randomNum = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomNum/$width/$height';
  }
}
