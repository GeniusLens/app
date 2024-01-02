import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/utils/debug_util.dart';

import 'community_page.dart';

class CommunityCard extends StatefulWidget {
  const CommunityCard(this.content, {super.key});

  final EEE content;

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.basicCardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              // 顶部圆角
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Constants.basicCardBorderRadius),
              ),
              child: Image(
                width: double.infinity,
                // height: widget.height,
                image: ExtendedImage.network(
                  widget.content.url,
                  fit: BoxFit.cover,
                ).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.content.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.content.title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Constants.captionSize,
                  color: Colors.grey[800],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: ExtendedImage.network(
                    DebugUtil.getRandomImageURL(),
                    fit: BoxFit.cover,
                  ).image,
                ),
                const SizedBox(width: 4),
                Text(
                  '${Random().nextInt(100)}' * (Random().nextInt(3) + 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Constants.captionSize - 2,
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.favorite_border, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${Random().nextInt(100)}',
                  style: TextStyle(
                    fontSize: Constants.captionSize - 2,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
