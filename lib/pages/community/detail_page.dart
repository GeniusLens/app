import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/utils/debug_util.dart';

class CommunityDetailPage extends StatefulWidget {
  const CommunityDetailPage({super.key});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  Widget _buildAppBarHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: ExtendedImage.network(
            DebugUtil.getRandomImageURL(),
            fit: BoxFit.cover,
          ).image,
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '用户名',
              style: TextStyle(fontSize: Constants.captionSize),
            ),
            const SizedBox(height: 2),
            Text(
              '作品${Random().nextInt(100)}    粉丝${Random().nextInt(100)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text('+ 关注')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarHeader(),
      ),
      body: Center(
        child: Text('Community Detail'),
      ),
    );
  }
}
