import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/request/common.dart';
import '../../data/entity/common.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> tabs = ["喜欢", "评论", "系统消息"];
  final Map<String, int> _tabType = {
    "喜欢": 1,
    "评论": 2,
    "系统消息": 3,
  };
  final List<MessageVO> messages = [];

  Future<void> _loadData() async {
    var data = await CommonAPi.getMessages();
    setState(() {
      messages.addAll(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _loadData();
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
          return RefreshIndicator(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                // 只选择对应的type
                itemCount: messages
                        .where((element) => element.type == _tabType[e])
                        .toList()
                        .length +
                    1,
                itemBuilder: (context, index) {
                  if (index ==
                      messages
                          .where((element) => element.type == _tabType[e])
                          .toList()
                          .length) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Center(
                        child: Text(
                          '已经到底部啦',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  return _MessageCard(
                    data: messages
                        .where((element) => element.type == _tabType[e])
                        .toList()[index],
                  );
                },
              ),
              onRefresh: () {
                messages.clear();
                return _loadData();
              });
        }).toList(),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.data});

  final MessageVO data;

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (data.senderAvatar != null)
            Container(
              margin: const EdgeInsets.only(right: 24),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 24,
                child: ExtendedImage.network(
                  data.senderAvatar ?? '',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  shape: BoxShape.circle,
                  cache: true,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.sender ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.message,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data.time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
