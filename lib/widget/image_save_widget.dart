import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageSaveWidget extends StatelessWidget {
  const ImageSaveWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '保存图片',
            style: TextStyle(
              fontSize: 18,
              color: context.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          // 保存和取消按钮
          GestureDetector(
            onTap: () async {
              // 保存图片到相册
              // 请求到图片的二进制数据
              var bytes = await Dio().get<List<int>>(
                imageUrl,
                options: Options(responseType: ResponseType.bytes),
              );
              if (bytes.data == null) {
                EasyLoading.showError('保存失败');
                return;
              }
              // 保存图片到相册
              // 保存成功后提示
              var result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(bytes.data!),
                quality: 60,
              );
              if (result['isSuccess']) {
                EasyLoading.showSuccess('保存成功');
              } else {
                EasyLoading.showError('保存失败');
              }
              Get.back();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                '保存图片到相册',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 取消按钮
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                '取消',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
