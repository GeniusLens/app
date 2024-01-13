import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/profile.dart';

class ProfilePanel extends StatelessWidget {
  const ProfilePanel(this.profile, {super.key});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PanelItem(title: '动态', value: profile.postCount.toString()),
          PanelItem(title: '粉丝', value: profile.fansCount.toString()),
          PanelItem(title: '关注', value: profile.followCount.toString()),
        ],
      ),
    );
  }
}

class PanelItem extends StatelessWidget {
  const PanelItem({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Constants.basicColor,
              fontSize: Constants.bodySize,
            ),
          ),
          const SizedBox(height: 8),
          Text(value),
        ],
      ),
    );
  }
}
