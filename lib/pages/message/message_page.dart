import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> tabs = ["喜欢", "评论", "系统消息"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
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
        title: const Text('消息'),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: TabBar(
            controller: _tabController,
            splashBorderRadius: BorderRadius.zero,
            // 不显示点击效果
            splashFactory: NoSplash.splashFactory,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: 10,
            itemBuilder: (context, index) => _MessageCard(),
          );
        }).toList(),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 24,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('用户',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('内容', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '时间',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
