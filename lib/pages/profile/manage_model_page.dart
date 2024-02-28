import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class ManageModelPage extends StatefulWidget {
  const ManageModelPage({super.key});

  @override
  State<ManageModelPage> createState() => _ManageModelPageState();
}

class _ManageModelPageState extends State<ManageModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的AI分身'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Image(
                    image: NetworkImage(
                      'https://picsum.photos/600/400?random=1',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Center(child: _InfoCard())),
              ],
            ),
          ),
          Container(
            height: 172,
            padding: const EdgeInsets.all(16),
            color: context.theme.cardColor,
            child: Column(
              children: [
                const Text('1 of 3'),
                SizedBox(
                  height: 96,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _ModelItem(isCurrent: index == 0);
                    },
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

class _ModelItem extends StatelessWidget {
  const _ModelItem({super.key, required this.isCurrent});

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    var size = isCurrent ? 48.0 : 32.0;
    return Container(
      margin: const EdgeInsets.all(8),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.theme.primaryColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 512,
      height: 148,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Row(
            children: [
              Text('AI分身',
                  style: TextStyle(
                      fontSize: 24,
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              // 画一个圆形的按钮
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRouter.functionPage);
                  },
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRouter.functionPage);
                  },
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('AI分身是一种新型的虚拟形象，可以用于社交、娱乐、工作等多种场景。',
              style: TextStyle(color: Colors.grey)),
          const Spacer(),
        ],
      ),
    );
  }
}
