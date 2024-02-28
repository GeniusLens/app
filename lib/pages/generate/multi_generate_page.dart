import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class MultiGeneratePage extends StatefulWidget {
  const MultiGeneratePage({super.key});

  @override
  State<MultiGeneratePage> createState() => _MultiGeneratePageState();
}

class _MultiGeneratePageState extends State<MultiGeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('多人生成'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const _MultiGenerateItem(),
              ),
            ),
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

class _MultiGenerateItem extends StatelessWidget {
  const _MultiGenerateItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 64,
            backgroundImage: ExtendedImage.network(
              "https://picsum.photos/800/800",
              fit: BoxFit.fill,
            ).image,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('分身名称', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Checkbox(value: false, onChanged: null),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
