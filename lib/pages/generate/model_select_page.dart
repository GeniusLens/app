import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class ModelSelectPage extends StatefulWidget {
  const ModelSelectPage({super.key});

  @override
  State<ModelSelectPage> createState() => _ModelSelectPageState();
}

class _ModelSelectPageState extends State<ModelSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择模型'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemCount: 10,
          itemBuilder: (context, index) => const _ModelItem(),
        ),
      ),
    );
  }
}

class _ModelItem extends StatelessWidget {
  const _ModelItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256 + 64,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 128,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/200/300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('名称', style: TextStyle(fontSize: 16)),
                const Spacer(),
                 GestureDetector(
                   onTap: () => Get.toNamed(AppRouter.soloGeneratePage),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '使用',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
