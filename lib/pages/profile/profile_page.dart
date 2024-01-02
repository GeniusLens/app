import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/pages/profile/profile_header.dart';
import 'package:genius_lens/pages/profile/profile_history.dart';
import 'package:genius_lens/pages/profile/profile_panel.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              title: const Text('我的'),
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed('/settings'),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            const SliverToBoxAdapter(child: ProfileHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: ProfilePanel()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Constants.globalPadding),
                child: ProfileHistory(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
