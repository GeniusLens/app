import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/request/generate.dart';
import '../../data/entity/generate.dart';

class ModelCreatePage extends StatefulWidget {
  const ModelCreatePage({super.key});

  @override
  State<ModelCreatePage> createState() => _ModelCreatePageState();
}

class _ModelCreatePageState extends State<ModelCreatePage> {
  final List<String> _steps = [
    '上传正面照片',
    '上传其他照片',
  ];
  late final PageController _pageController;
  int _selectedIndex = 0;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _frontImage;
  bool _isOtherLoading = false;
  final List<XFile> _otherImages = [];

  final List<SampleVO> _samples = [];

  Future<void> _loadSamples() async {
    var result = await GenerateApi.getSamples(0);
    setState(() {
      _samples.addAll(result);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _selectedIndex = _pageController.page!.round();
      });
    });
    _loadSamples();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建分身'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _steps.length,
                (index) => GestureDetector(
                  onTap: () => _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    margin: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${index + 1}. ${_steps[index]}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedIndex == index
                            ? context.theme.primaryColor
                            : Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: (_selectedIndex == 1)
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                Get.snackbar('创建成功', '请前往我的分身查看',
                    snackPosition: SnackPosition.BOTTOM);
                Future.delayed(const Duration(milliseconds: 1000), () {
                  Get.toNamed(AppRouter.manageModelPage);
                });
              },
              child: const Icon(Icons.check),
            )
          : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: [
          _BasePage(
            key: const Key('front'),
            content: Column(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    XFile? file = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      setState(() {
                        _frontImage = file;
                      });
                      var result = await CommonAPi.uploadImage(file.path);
                      if (!result) {
                        Get.snackbar('上传失败', '请检查网络连接或稍后重试',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    }
                  },
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      // 减去AppBar高度
                      height: (_frontImage == null)
                          ? 196
                          : Get.height -
                              MediaQuery.of(context).padding.top -
                              kToolbarHeight -
                              256 -
                              64,
                      width: (_frontImage == null) ? 196 : null,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: (_frontImage != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.file(
                                File(_frontImage!.path),
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.add,
                                size: 48,
                                color: Colors.grey[600],
                              ),
                            ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            goodSamples: _samples
                .where((element) => element.type == 1)
                .map((e) => e.url)
                .toList(),
            badSamples: _samples
                .where((element) => element.type == 2)
                .map((e) => e.url)
                .toList(),
          ),
          _BasePage(
            key: const Key('other'),
            content: Container(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _otherImages.length + 1,
                itemBuilder: (context, index) {
                  var content = index < _otherImages.length
                      ? Image.file(
                          File(_otherImages[index].path),
                          fit: BoxFit.fill,
                        )
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: (_isOtherLoading)
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.add,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                        );
                  return GestureDetector(
                    onTap: () async {
                      if (index < _otherImages.length) {
                        // 弹窗询问是否删除
                        bool? result = await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('删除照片'),
                            content: const Text('确定要删除这张照片吗？'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('确定'),
                              ),
                            ],
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            _otherImages.removeAt(index);
                          });
                        }
                        return;
                      }

                      XFile? file = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (file != null) {
                        setState(() {
                          _isOtherLoading = true;
                        });
                        var result = await CommonAPi.uploadImage(file.path);
                        if (!result) {
                          Get.snackbar('上传失败', '请检查网络连接或稍后重试',
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        setState(() {
                          _otherImages.add(file);
                          _isOtherLoading = false;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: content,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (index < _otherImages.length)
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                ' 正面',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const Spacer(),
                            ],
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            explain: const [
              '请上传一张正面照片，确保照片中的人脸清晰可见。',
              '请上传一张或多张其他照片，确保照片中的人脸清晰可见。',
            ],
            goodSamples: _samples
                .where((element) => element.type == 1)
                .map((e) => e.url)
                .toList(),
            badSamples: _samples
                .where((element) => element.type == 2)
                .map((e) => e.url)
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BasePage extends StatefulWidget {
  const _BasePage(
      {super.key,
      required this.content,
      this.explain = const [],
      required this.goodSamples,
      required this.badSamples});

  final Widget content;
  final List<String> explain;
  final List<String> goodSamples;
  final List<String> badSamples;

  @override
  State<_BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<_BasePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.content,
        ),
        if (widget.explain.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widget.explain
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '* $e',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: const Row(
            children: [
              Expanded(child: Divider()),
              SizedBox(width: 16),
              Text(
                '示例',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 16),
              Expanded(child: Divider()),
            ],
          ),
        ),
        Container(
          height: 96 + 16 * 2,
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.goodSamples.length + widget.badSamples.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ExtendedImage.network(
                            index < widget.goodSamples.length
                                ? widget.goodSamples[index]
                                : widget.badSamples[
                                    index - widget.goodSamples.length],
                            cache: true,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ExtendedRawImage(
                                  image: state.extendedImageInfo?.image,
                                  fit: BoxFit.cover);
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < widget.goodSamples.length
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: index < widget.goodSamples.length
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // 隐私声明
        SizedBox(
          height: 32,
          child: Text(
            '点击下一步，即表示您同意《隐私声明》',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
