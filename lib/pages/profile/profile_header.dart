import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/data/entity/profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.profile, {super.key});

  final ProfileEntity profile;

  final TextStyle _nameStyle = const TextStyle(
    fontSize: 22,
  );

  final TextStyle _signatureStyle = const TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: ExtendedImage.network(
              profile.avatarUrl,
              cache: true,
            ).image,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  profile.signature ?? '这个人很懒，什么都没有留下',
                  style: _signatureStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
