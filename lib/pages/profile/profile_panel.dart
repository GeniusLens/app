import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({super.key});

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PanelItem(title: '动态', value: Random().nextInt(100).toString()),
          PanelItem(title: '粉丝', value: Random().nextInt(100).toString()),
          PanelItem(title: '关注', value: Random().nextInt(100).toString()),
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
