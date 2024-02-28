import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class SoloGeneratePage extends StatefulWidget {
  const SoloGeneratePage({super.key});

  @override
  State<SoloGeneratePage> createState() => _SoloGeneratePageState();
}

class _SoloGeneratePageState extends State<SoloGeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单人生成'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(Icons.chevron_left, size: 48),
                  ),
                ),
                Container(
                  height: 224,
                  width: 224,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 128,
                    backgroundImage: ExtendedImage.network(
                      "https://picsum.photos/800/800",
                      fit: BoxFit.fill,
                    ).image,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(Icons.chevron_right, size: 48),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('分身名称', style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('2 of 6', style: TextStyle(fontSize: 12)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Get.toNamed(AppRouter.generateResultPage),
              child: Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text('生成',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
