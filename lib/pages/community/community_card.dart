import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/utils/debug_util.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard(this.content, this.onTap, {super.key});

  final CommunityRecommendEntity content;
  final VoidCallback onTap;

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
                image: ExtendedImage.network(
                  content.coverUrl,
                  fit: BoxFit.cover,
                ).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              content.title,
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
                    content.userAvatarUrl,
                    fit: BoxFit.cover,
                  ).image,
                ),
                const SizedBox(width: 4),
                Text(
                  content.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Constants.captionSize - 2,
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      content.isLike
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.grey[700],
                              size: 16,
                            ),
                      const SizedBox(width: 4),
                      Text(
                        content.likeCount.toString(),
                        style: TextStyle(
                          fontSize: Constants.captionSize - 2,
                          color: Colors.grey[700],
                        ),
                      )
                    ],
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
