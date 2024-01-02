import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';

class Demo {
  String url;
  String title;
  String subtitle;

  Demo(this.url, this.title, this.subtitle);
}

class FavoriteCard extends StatefulWidget {
  const FavoriteCard(this.content, {super.key});

  final Demo content;

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  final TextStyle _titleStyle = const TextStyle(
    fontSize: Constants.bodySize,
    color: Colors.white,
  );

  final TextStyle _subtitleStyle = const TextStyle(
    fontSize: Constants.captionSize,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.basicCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.basicCardBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.basicCardBorderRadius),
          image: DecorationImage(
            image: ExtendedImage.network(
              widget.content.url,
              fit: BoxFit.cover,
              cache: true,
              key: Key(DebugUtil.getRandomImageURL()),
              // 处理图片加载失败和加载过程中的情况
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case LoadState.completed:
                    return ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      fit: BoxFit.cover,
                    );
                  case LoadState.failed:
                    return const Center(
                      child: Icon(Icons.error),
                    );
                }
              },
            ).image,
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.content.title,
                style: _titleStyle,
              ),
              Text(
                widget.content.subtitle,
                style: _subtitleStyle,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
