import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/common.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TryOnGeneratePage extends StatefulWidget {
  const TryOnGeneratePage({super.key});

  @override
  State<TryOnGeneratePage> createState() => _TryOnGeneratePageState();
}

class _TryOnGeneratePageState extends State<TryOnGeneratePage> {
  late final CategoryVO _category;
  late final FunctionVO _function;
  int? _taskId;
  TaskVO? task;
  final GlobalKey _panelKey = GlobalKey();
  final List<ModelVO> _models = [];
  final List<ClothVO> _clothes = [];
  final List<String> _results = [];
  bool _waiting = false;
  late final SwiperController _swiperCtrl;

  int _selectedCloth = -1;
  int _selectedModel = -1;

  void _loadTask() {
    // 轮询获取结果
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      var result = await GenerateApi.getTaskInfo(_taskId!);
      if (result.statusCode == 3 || result.statusCode == 4) {
        timer.cancel();
        EasyLoading.dismiss();
        // 处理失败情况
        // && _waiting 是为了防止在试穿失败时重复弹出Toast，所谓防抖
        if (result.statusCode == 4 && _waiting) {
          EasyLoading.showToast('试穿失败');
          setState(() {
            _waiting = false;
          });
          return;
        }

        // 处理成功情况
        // 按照,分割并去掉最后一个空字符串
        task = result;
        var resultList = task!.result!.split(',');
        setState(() {
          _waiting = false;
          _results.clear();
          _results.addAll(resultList);
        });
        if (_swiperCtrl.index == 0) {
          _swiperCtrl.next();
        }
      }
    });
  }

  Future<void> _loadClothes() async {
    var data = await CommonAPi.getClothes();
    setState(() {
      _clothes.clear();
      _clothes.addAll(data);
    });
  }

  Future<void> _loadModels() async {
    var data = await CommonAPi.getModels();
    setState(() {
      _models.clear();
      _models.addAll(data);
    });
  }

  Future<void> _loadFunction() async {
    var result = await GenerateApi.getFunctionList(_category.name);
    if (result.isNotEmpty) {
      setState(() {
        _function =
            result.where((element) => element.name == _category.name).first;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _category = Get.arguments as CategoryVO;
    _swiperCtrl = SwiperController();
    _loadModels();
    _loadFunction();
    _loadClothes();
  }

  @override
  void dispose() {
    // 及时销毁定时器
    if (_taskId != null) {
      Timer.periodic(const Duration(seconds: 1), (timer) {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              if (_waiting) {
                EasyLoading.showToast('正在试穿中');
                return;
              }
              if (_selectedCloth == -1) {
                EasyLoading.showToast('请选择衣服');
                return;
              }
              setState(() => _waiting = true);
              List<String> images = [];
              images.add(_models[_selectedModel].url!);
              images.add(_clothes[_selectedCloth].url!);
              var result = await GenerateApi.submitTask(
                f: _function,
                images: images,
                clothId: _clothes[_selectedCloth].id,
              );
              print('Result Id: $result');
              if (result == null) {
                EasyLoading.showToast('提交失败');
                return;
              }
              setState(() => _taskId = result);
              _loadTask();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: (_waiting)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LoadingAnimationWidget.prograssiveDots(
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : const Text(
                      '试穿',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SlidingUpPanel(
        panel: Container(
          key: _panelKey,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const Text(
                  '选择试穿的衣服',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _clothes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _clothes.length) {
                      return GestureDetector(
                        onTap: () async {
                          EasyLoading.show(status: '上传中...');
                          var file = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          var upload = await CommonAPi.uploadFile(file!.path);
                          if (upload != null) {
                            setState(() {
                              _clothes.add(ClothVO(
                                url: upload,
                              ));
                              _selectedCloth = _clothes.length - 1;
                            });
                            EasyLoading.dismiss();
                            EasyLoading.showToast('上传成功');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_waiting) return;
                          if (_selectedCloth == index) {
                            _selectedCloth = -1;
                          } else {
                            _selectedCloth = index;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: (_selectedCloth == index)
                              ? Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                )
                              : null,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ExtendedImage.network(
                            _clothes[index].url!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        maxHeight: MediaQuery.of(context).size.height * (1 - 0.618),
        minHeight: 196,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        body: Column(
          children: [
            Expanded(
              child: Swiper(
                controller: _swiperCtrl,
                itemCount: 1 + (_results.isEmpty ? 0 : 1),
                scrollDirection: Axis.vertical,
                loop: false,
                control: SwiperControl(
                  color: context.theme.primaryColor,
                  disableColor: Colors.grey[400]!,
                  size: 24,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildModelLevel(context);
                  } else {
                    return _buildResultLevel(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 294),
          ],
        ),
      ),
    );
  }

  Swiper _buildModelLevel(BuildContext context) {
    return Swiper(
      itemCount: _models.length + 1,
      loop: false,
      scale: 0.8,
      viewportFraction: 0.7,
      onIndexChanged: (index) => setState(() => _selectedModel = index),
      itemBuilder: (context, index) {
        if (index == _models.length) {
          return Center(
            child: GestureDetector(
              onTap: () async {
                var file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) {
                  EasyLoading.show(status: '上传中...');
                  var upload = await CommonAPi.uploadFile(file.path);
                  if (upload != null) {
                    setState(() {
                      _models.add(ModelVO(
                        url: upload,
                      ));
                    });
                    EasyLoading.dismiss();
                    EasyLoading.showToast('上传成功');
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: context.theme.primaryColor,
                  size: 64,
                ),
              ),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 32, top: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExtendedImage.network(
                    _models[index].url!,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Center(
                          child: LoadingAnimationWidget.prograssiveDots(
                            color: context.theme.primaryColor,
                            size: 32,
                          ),
                        );
                      } else if (state.extendedImageLoadState ==
                          LoadState.failed) {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                      return null;
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 加载时添加一个蒙版
              AnimatedOpacity(
                opacity: _waiting ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Swiper _buildResultLevel(BuildContext context) {
    return Swiper(
      itemCount: (_results.isEmpty) ? 1 : _results.length,
      loop: false,
      scale: 0.8,
      viewportFraction: 0.7,
      itemBuilder: (context, index) {
        if (_results.isEmpty) {
          if (_waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: context.theme.primaryColor,
                size: 48,
              ),
            );
          } else {
            return const Center(
              child: Text(
                '暂无结果',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 32, top: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExtendedImage.network(
                    _results[index],
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Center(
                          child: LoadingAnimationWidget.prograssiveDots(
                            color: context.theme.primaryColor,
                            size: 32,
                          ),
                        );
                      } else if (state.extendedImageLoadState ==
                          LoadState.failed) {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                      return null;
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 加载时添加一个蒙版
              AnimatedOpacity(
                opacity: _waiting ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
