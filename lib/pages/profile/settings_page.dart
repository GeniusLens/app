import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _Context {
  final IconData icon;
  final String title;
  final String route;
  final bool showMore;

  const _Context({
    required this.icon,
    required this.title,
    required this.route,
    this.showMore = false,
  });
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<_Context> _contexts = [
    const _Context(
      icon: Icons.lock,
      title: '账号与安全',
      route: '/setting/account',
    ),
    const _Context(
      icon: Icons.notifications,
      title: '消息通知',
      route: '/setting/notification',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _CardWrapper(contexts: _contexts),
            const _CardWrapper(contexts: [
              _Context(
                icon: Icons.help,
                title: '退出登录',
                route: '/setting/logout',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _CardWrapper extends StatelessWidget {
  const _CardWrapper({super.key, required this.contexts});

  final List<_Context> contexts;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        children: List.generate(
          contexts.length,
          (index) => _CardItem(data: contexts[index]),
        ),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({super.key, required this.data});

  final _Context data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(data.icon, color: context.theme.primaryColor),
      title: Text(data.title),
      trailing: (data.showMore)
          ? Icon(Icons.chevron_right, color: context.theme.primaryColor)
          : null,
      onTap: () => Get.toNamed(data.route),
    );
  }
}
