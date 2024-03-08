import 'package:flutter/material.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WearEvaluationPage extends StatefulWidget {
  const WearEvaluationPage({super.key});

  @override
  State<WearEvaluationPage> createState() => _WearEvaluationPageState();
}

class _WearEvaluationPageState extends State<WearEvaluationPage> {
  late final CategoryVO category;
  String? _imageUrl;
  bool _uploading = false;
  String? _recommend = null;

  @override
  void initState() {
    super.initState();
    category = Get.arguments as CategoryVO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: (_imageUrl == null)
                ? Center(
                    child: (!_uploading)
                        ? GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300]!,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Text('上传图片以获取智能建议'),
                            ),
                            onTap: () async {
                              setState(() {
                                _uploading = true;
                              });
                              var image = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              _imageUrl =
                                  await CommonAPi.uploadFile(image!.path);
                              setState(() {
                                _uploading = false;
                                _recommend = '智能建议' * 24;
                              });
                            })
                        : const CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(_imageUrl!),
                  ),
          ),
          if (_recommend != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    '智能建议',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _recommend = null;
                        _imageUrl = null;
                      });
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          if (_recommend != null)
            AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: context.theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(_recommend ?? ''),
            )
        ],
      ),
    );
  }
}
