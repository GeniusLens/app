import 'package:flutter/material.dart';
import 'package:genius_lens/api/profile.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/profile.dart';
import 'package:genius_lens/pages/profile/profile_header.dart';
import 'package:genius_lens/pages/profile/profile_history.dart';
import 'package:genius_lens/pages/profile/profile_panel.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileEntity? profile;
  final List<_ActionContext> actions1 = [
    _ActionContext(
      icon: Icons.history,
      title: '我的AI作品',
      route: AppRouter.profilePage,
    ),
    _ActionContext(
      icon: Icons.manage_search,
      title: '管理分身',
      route: AppRouter.manageModelPage,
    ),
    _ActionContext(
      icon: Icons.favorite,
      title: '我的点赞',
      route: AppRouter.profilePage,
    ),
    _ActionContext(
      icon: Icons.star,
      title: '我的收藏',
      route: AppRouter.profilePage,
    ),
  ];

  final List<_ActionContext> actions2 = [
    _ActionContext(
      icon: Icons.settings,
      title: '设置',
      route: AppRouter.profilePage,
    ),
    _ActionContext(
      icon: Icons.help,
      title: '帮助与反馈',
      route: AppRouter.profilePage,
    ),
    _ActionContext(
      icon: Icons.info,
      title: '关于我们',
      route: AppRouter.profilePage,
    ),
  ];

  Future<void> _loadData() async {
    try {
      var profile = await ProfileApi().getProfile();
      setState(() => this.profile = profile);
    } catch (e) {
      Get.snackbar('加载失败', e.toString());
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 16),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRouter.messagePage),
                      child: Icon(Icons.notifications_outlined, size: 28),
                    ),
                  )
                ],
              ),
              if (profile != null) ProfileHeader(profile!),
              const SizedBox(height: 16),
              if (profile != null) ProfilePanel(profile!),
              const SizedBox(height: 16),
              _ProfileActions(actions: actions1),
              _ProfileActions(actions: actions2),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileActions extends StatefulWidget {
  const _ProfileActions({super.key, required this.actions});

  final List<_ActionContext> actions;

  @override
  State<_ProfileActions> createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<_ProfileActions> {
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
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          widget.actions.length,
          (index) => _ProfileActionItem(data: widget.actions[index]),
        ),
      ),
    );
  }
}

class _ProfileActionItem extends StatelessWidget {
  const _ProfileActionItem({super.key, required this.data});

  final _ActionContext data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (data.icon != null)
          ? Icon(data.icon, color: context.theme.primaryColor)
          : null,
      title: Text(data.title),
      trailing: data.showTrailing
          ? Icon(Icons.chevron_right, color: context.theme.primaryColor)
          : null,
      onTap: () => Get.toNamed(data.route),
    );
  }
}

class _ActionContext {
  final IconData? icon;
  final String title;
  final bool showTrailing;
  final String route;

  _ActionContext({
    this.icon,
    required this.title,
    this.showTrailing = true,
    required this.route,
  });
}
