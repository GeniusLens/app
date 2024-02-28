import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class GenerateResultPage extends StatefulWidget {
  const GenerateResultPage({super.key});

  @override
  State<GenerateResultPage> createState() => _GenerateResultPageState();
}

class _GenerateResultPageState extends State<GenerateResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成结果'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => Container(
                  height: 256 + 64,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://picsum.photos/800/800",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.theme.primaryColor,
                ),
                child: const Text(
                  '更像我一点',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: context.theme.primaryColor,
                      ),
                      child: const Text(
                        '保存全部',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: context.theme.primaryColor,
                      ),
                      child: const Text(
                        '保存全部',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
