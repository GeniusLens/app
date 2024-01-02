import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/utils/debug_util.dart';

class DetailSharingCard extends StatefulWidget {
  const DetailSharingCard({super.key});

  @override
  State<DetailSharingCard> createState() => _DetailSharingCardState();
}

class _DetailSharingCardState extends State<DetailSharingCard> {
  final TextStyle _titleStyle = const TextStyle(
    fontSize: Constants.bodySize,
    color: Constants.basicColor,
  );

  String _getUrl(int index) {
    String url = '';
    switch (index) {
      case 0:
        url = 'https://s2.loli.net/2024/01/02/i9RkNlHGEXAcrMD.png';
      case 1:
        url = 'https://s2.loli.net/2024/01/02/CzW9GvmMaKNse7U.png';
      case 2:
        url = 'https://s2.loli.net/2024/01/02/47J8ICWHAh6VsMU.png';
      default:
        url = DebugUtil.getRandomImageURL();
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.basicCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.basicCardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '用户分享',
                  style: _titleStyle,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 128,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 96,
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: ExtendedImage.network(
                          _getUrl(index),
                          fit: BoxFit.cover,
                          cache: true,
                          key: Key(DebugUtil.getRandomImageURL()),
                        ).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
