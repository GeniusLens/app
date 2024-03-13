import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/widget/image_save_widget.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({super.key});

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late final String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = Get.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          // 点击图片退出
          Get.back();
        },
        onLongPress: () {
          // 长按图片保存
          // 弹出保存图片的底部弹窗
          Get.bottomSheet(ImageSaveWidget(imageUrl: imageUrl));
        },
        child: PhotoView(
          loadingBuilder: (context, event) {
            return Center(
              child: LoadingAnimationWidget.horizontalRotatingDots(
                size: 32,
                color: Colors.white,
              ),
            );
          },
          imageProvider: ExtendedImage.network(
            imageUrl,
            cache: true,
            enableMemoryCache: true,
            clearMemoryCacheIfFailed: true,
            enableLoadState: true,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return Center(
                    child: LoadingAnimationWidget.horizontalRotatingDots(
                      size: 32,
                      color: Colors.white,
                    ),
                  );
                case LoadState.completed:
                  return null;
                case LoadState.failed:
                  return const Center(
                    child: Text('加载失败'),
                  );
              }
            },
          ).image,
        ),
      ),
    );
  }
}
