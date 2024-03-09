import 'package:extended_image/extended_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WearEvaluationPage extends StatefulWidget {
  const WearEvaluationPage({super.key});

  @override
  State<WearEvaluationPage> createState() => _WearEvaluationPageState();
}

class _WearEvaluationPageState extends State<WearEvaluationPage>
    with TickerProviderStateMixin {
  late final CategoryVO category;
  String? _imageUrl;
  String? _referenceUrl;
  bool _uploading = false;
  bool _thingking = false;
  bool _getReferencing = false;
  bool _flip = false;
  String? _recommend;
  late final FlipCardController? _flipCardController;

  @override
  void initState() {
    super.initState();
    category = Get.arguments as CategoryVO;
    _flipCardController = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: context.theme.primaryColor,
            onPressed: () {
              if (_flip) {
                _flipCardController?.toggleCard();
              }
              setState(() {
                _imageUrl = null;
                _referenceUrl = null;
                _recommend = null;
              });
            },
          ),
        ],
      ),
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
        body: Column(
          // margin: const EdgeInsets.only(bottom: 172),
          children: [
            const Spacer(),
            if (_imageUrl == null && !_thingking)
              Expanded(
                child: Center(
                  child: LoadingAnimationWidget.beat(
                    color: context.theme.primaryColor,
                    size: 42,
                  ),
                ),
              ),
            if (_imageUrl != null)
              FlipCard(
                direction: FlipDirection.HORIZONTAL,
                flipOnTouch: _referenceUrl != null,
                onFlipDone: (status) {
                  setState(() {
                    _flip = status;
                  });
                },
                speed: 300,
                controller: _flipCardController,
                front: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.theme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ExtendedImage.network(
                        _imageUrl!,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.loading) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: context.theme.primaryColor,
                                size: 24,
                              ),
                            );
                          }
                          return null;
                        },
                        fit: BoxFit.fitWidth,
                        cache: true,
                      ),
                    ),
                  ),
                ),
                back: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.theme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ExtendedImage.network(
                        _referenceUrl ?? '',
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.loading) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: context.theme.primaryColor,
                                size: 24,
                              ),
                            );
                          }
                          return null;
                        },
                        fit: BoxFit.fitWidth,
                        cache: true,
                      ),
                    ),
                  ),
                ),
              ),
            const Spacer(),
            const SizedBox(height: 172),
          ],
        ),
        panel: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_imageUrl == null && !_uploading && !_thingking)
                  GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text(
                          '上传图片以获取智能建议',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          _uploading = true;
                        });
                        var image = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        _imageUrl = await CommonAPi.uploadFile(image!.path);
                        setState(() {
                          _uploading = false;
                          _thingking = true;
                        });
                        if (_imageUrl != null) {
                          var recommend = await GenerateApi.wearEvaluation(
                            _imageUrl!,
                          );
                          setState(() {
                            _recommend = recommend;
                            _thingking = false;
                          });
                        }
                      }),
                if (_uploading || _thingking)
                  LoadingAnimationWidget.horizontalRotatingDots(
                    color: context.theme.primaryColor,
                    size: 32,
                  ),
                if (_recommend != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          '智能建议',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: context.theme.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            setState(() => _getReferencing = true);
                            var result = await GenerateApi.getReferenceImage(
                              _recommend!,
                            );
                            setState(() {
                              _referenceUrl = result;
                              // 仅在处于正面时翻转卡片
                              if (_flip) {
                                _flipCardController?.toggleCard();
                              }
                              _getReferencing = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300]!,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _getReferencing
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child:
                                        LoadingAnimationWidget.prograssiveDots(
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                : Text(
                                    _referenceUrl == null ? '获取参考' : '重新获取',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_recommend != null) Text(_recommend ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
