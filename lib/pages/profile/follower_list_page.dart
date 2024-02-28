import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowerListPage extends StatefulWidget {
  const FollowerListPage({super.key});

  @override
  State<FollowerListPage> createState() => _FollowerListPageState();
}

class _FollowerListPageState extends State<FollowerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('粉丝'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const _FollowerItem();
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 1, indent: 72);
          },
        ),
      ),
    );
  }
}

class _FollowerItem extends StatelessWidget {
  const _FollowerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: context.theme.primaryColor,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('用户名', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text('简介'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '回关',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
