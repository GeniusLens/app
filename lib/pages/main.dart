import 'package:flutter/material.dart';
import 'package:genius_lens/pages/community/community_page.dart';
import 'package:genius_lens/pages/create/create_page.dart';
import 'package:genius_lens/pages/favorite/favorite_page.dart';
import 'package:genius_lens/pages/profile/profile_page.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// The width of the center space in the [BottomAppBar].
  static const double _centerWidth = 24;

  /// The index into [pages] for the current page.
  int _selectedIndex = 0;

  /// The list of pages to show in the [BottomNavigationBar].
  final List<Widget> _pages = <Widget>[
    const CreatePage(),
    const FavoritePage(),
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed(AppRouter.functionPage),
        child: const Icon(Icons.draw),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() => _selectedIndex = 0);
              },
              icon: (_selectedIndex == 0)
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() => _selectedIndex = 1);
              },
              icon: (_selectedIndex == 1)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ),
            const SizedBox(width: _centerWidth),
            IconButton(
              onPressed: () {
                setState(() => _selectedIndex = 2);
              },
              icon: (_selectedIndex == 2)
                  ? const Icon(Icons.people)
                  : const Icon(Icons.people_alt_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() => _selectedIndex = 3);
              },
              icon: (_selectedIndex == 3)
                  ? const Icon(Icons.person)
                  : const Icon(Icons.person_outline),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
