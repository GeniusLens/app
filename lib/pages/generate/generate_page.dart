import 'package:flutter/material.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _labels = ["全部", "AI趣图像", "AI趣穿搭"];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          title: TabBar(
            controller: _tabController,
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            tabAlignment: TabAlignment.start,
            tabs: _labels.map((e) => Tab(text: e)).toList(),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _GenerateList(),
              _GenerateList(),
              _GenerateList(),
            ],
          ),
        ));
  }
}

class _GenerateList extends StatefulWidget {
  const _GenerateList({super.key});

  @override
  State<_GenerateList> createState() => _GenerateListState();
}

class _GenerateListState extends State<_GenerateList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return const _GenerateItem();
    });
  }
}

class _GenerateItem extends StatelessWidget {
  const _GenerateItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256 + 64,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://picsum.photos/800/800",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("AI趣图像", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("AI趣图像能够将照片转换为卡通风格"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRouter.selectModelPage),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "马上制作",
                      style: TextStyle(color: Colors.white),
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
