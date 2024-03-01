import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/user.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/user.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserVO? user;
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
      route: AppRouter.settingPage,
    ),
    _ActionContext(
      icon: Icons.help,
      title: '帮助与反馈',
      route: AppRouter.helpPage,
    ),
    _ActionContext(
      icon: Icons.info,
      title: '关于我们',
      route: AppRouter.aboutPage,
    ),
  ];

  Future<void> _loadData() async {
    var data = await UserApi.getUserInfo();
    setState(() {
      user = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
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
                      child: const Icon(Icons.notifications_outlined, size: 28),
                    ),
                  )
                ],
              ),
              if (user != null) ProfileHeader(user!),
              const SizedBox(height: 16),
              if (user != null) ProfilePanel(user!),
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.user, {super.key});

  final UserVO user;

  final TextStyle _nameStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  final TextStyle _signatureStyle = const TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: ExtendedImage.network(
              user.avatar ?? '',
              cache: true,
            ).image,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.nickname ?? '未知用户',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  user.quote ?? '这个人很懒，什么都没有留下',
                  style: _signatureStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            child: GestureDetector(
              child: const Icon(Icons.chevron_right, size: 32),
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePanel extends StatelessWidget {
  const ProfilePanel(this.user, {super.key});

  final UserVO user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PanelItem(title: '作品', value: '11', route: AppRouter.profilePage),
          PanelItem(
              title: '粉丝', value: '222', route: AppRouter.followerListPage),
          PanelItem(
              title: '关注', value: '22', route: AppRouter.followerListPage),
        ],
      ),
    );
  }
}

class PanelItem extends StatelessWidget {
  const PanelItem(
      {super.key,
      required this.title,
      required this.value,
      required this.route});

  final String title;
  final String value;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Constants.basicColor,
                fontSize: Constants.bodySize,
              ),
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
