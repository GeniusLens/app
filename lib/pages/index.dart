import 'package:flutter/material.dart';
import 'package:genius_lens/pages/community/community_page.dart';
import 'package:genius_lens/pages/entrance/entrance_page.dart';
import 'package:genius_lens/pages/generate/generate_page.dart';
import 'package:genius_lens/pages/profile/profile_page.dart';
import 'package:get/get.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  /// The index into [pages] for the current page.
  int _selectedIndex = 0;

  /// The list of pages to show in the [BottomNavigationBar].
  final List<Widget> _pages = <Widget>[
    const EntrancePage(),
    const GeneratePage(),
    const CommunityPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _BottomItem(
              icon: Icons.home_outlined,
              label: '首页',
              selected: _selectedIndex == 0,
              hasNotification: false,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            _BottomItem(
              icon: Icons.draw_outlined,
              label: 'AI趣',
              selected: _selectedIndex == 1,
              hasNotification: (_selectedIndex + 1) % 2 == 0,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            _BottomItem(
              icon: Icons.explore_outlined,
              label: '社区',
              selected: _selectedIndex == 2,
              hasNotification: false,
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            _BottomItem(
              icon: Icons.person_outline,
              label: '我的',
              selected: _selectedIndex == 3,
              hasNotification: false,
              onTap: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.hasNotification,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool hasNotification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Badge(
        label: const Icon(
          Icons.circle,
          size: 6,
          color: Colors.redAccent,
        ),
        isLabelVisible: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: selected ? context.theme.primaryColor : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: selected ? context.theme.primaryColor : Colors.grey,
              ),
            ),
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 28,
                color: context.theme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
