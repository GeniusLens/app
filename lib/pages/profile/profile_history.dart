import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';

class ProfileHistory extends StatefulWidget {
  const ProfileHistory({super.key});

  @override
  State<ProfileHistory> createState() => _ProfileHistoryState();
}

class _ProfileHistoryState extends State<ProfileHistory> {
  final double _itemSize = 96;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('足迹', style: TextStyle(fontSize: Constants.subtitleSize)),
        const SizedBox(height: 16),
        SizedBox(
          height: _itemSize,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                width: _itemSize,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
