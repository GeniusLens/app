import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/utils/debug_util.dart';

class FunctionCard extends StatefulWidget {
  const FunctionCard({super.key, this.title, this.description});

  final String? title;
  final String? description;

  @override
  State<FunctionCard> createState() => _FunctionCardState();
}

class _FunctionCardState extends State<FunctionCard> {
  final TextStyle _titleStyle = const TextStyle(
    fontSize: 22,
    color: Colors.white,
  );

  final TextStyle _subtitleStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  String _getImageUrl(String? name) {
    if (name == '多人写真') {
      return 'https://s2.loli.net/2024/01/02/e436CFiDbwSnLjM.png';
    } else if (name == 'AI趣编辑') {
      return 'https://s2.loli.net/2024/01/02/dFBhqfstMWgxTPa.png';
    } else if (name == '萌宠合照') {
      return 'https://nyanpedia.com/wordpress/wp-content/uploads/2017/10/shutterstock_331765481.jpg';
    } else if (name == 'AI趣穿搭') {
      return 'https://s2.loli.net/2024/01/02/jIfmdrYEn2lSOLB.png';
    } else if (name == '单人写真') {
      return 'https://s2.loli.net/2024/01/02/y5JOI2zQ1XFLfUd.jpg';
    }
    return DebugUtil.getRandomImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.basicCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.basicCardBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 148,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.basicCardBorderRadius),
          image: DecorationImage(
            image: ExtendedImage.network(
              _getImageUrl(widget.title),
              fit: BoxFit.cover,
              cache: true,
              key: Key(DebugUtil.getRandomImageURL()),
            ).image,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? '功能名称',
              style: _titleStyle,
            ),
            const SizedBox(height: 4),
            Text(
              widget.description ?? '功能描述',
              style: _subtitleStyle,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
