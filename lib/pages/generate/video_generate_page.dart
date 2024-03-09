import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoGeneratePage extends StatefulWidget {
  const VideoGeneratePage({super.key});

  @override
  State<VideoGeneratePage> createState() => _VideoGeneratePageState();
}

class _VideoGeneratePageState extends State<VideoGeneratePage> {
  late final CategoryVO function;
  VideoPlayerController? _controller;
  final List<LoraVO> _loras = [];
  int _selectedIndex = -1;
  String? _videoUrl;
  bool _uploading = false;

  Future<void> _fetchLoraList() async {
    var list = await GenerateApi.getUserLoraList();
    setState(() {
      _loras.clear();
      _loras.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    function = Get.arguments as CategoryVO;
    _fetchLoraList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(function.name),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: (_videoUrl == null)
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        _uploading = true;
                      });
                      var video = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      _videoUrl = await CommonAPi.uploadFile(video!.path);

                      setState(() {
                        _uploading = false;
                        _controller = VideoPlayerController.networkUrl(
                            Uri.parse(_videoUrl!))
                          ..initialize().then((_) {
                            _controller!.setLooping(true);
                            _controller!.play();
                          });
                      });
                    },
                    child: _uploading
                        ? const CircularProgressIndicator()
                        : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              '上传视频',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  )
                : Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
          ),
        ),
        if (_loras.isNotEmpty)
          Text(
            '选择分身',
            style: TextStyle(
              fontSize: 16,
              color: context.theme.primaryColor,
            ),
          ),
        if (_loras.isNotEmpty)
          Container(
            height: 128,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Swiper(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedIndex == index) {
                        _selectedIndex = -1;
                      } else {
                        _selectedIndex = index;
                      }
                    });
                  },
                  child: _ModelItem(
                    isCurrent:
                        _selectedIndex == -1 ? false : _selectedIndex == index,
                    model: _loras[index],
                  ),
                );
              },
              scale: 0.8,
              viewportFraction: 0.35,
              itemCount: _loras.length,
            ),
          ),
        if (_videoUrl != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Row(children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _videoUrl = null;
                    _controller!.dispose();
                    _controller = null;
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.redAccent),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  if (_selectedIndex == -1) {
                    EasyLoading.showError('请选择分身');
                    return;
                  }
                  GenerateApi.submitTask();
                  Get.offAndToNamed(AppRouter.manageTaskPage);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  child:
                      const Text('生成视频', style: TextStyle(color: Colors.white)),
                ),
              )
            ]),
          ),
      ]),
    );
  }
}

class _ModelItem extends StatelessWidget {
  const _ModelItem({required this.isCurrent, required this.model});

  final bool isCurrent;
  final LoraVO model;

  @override
  Widget build(BuildContext context) {
    var size = isCurrent ? 48.0 : 28.0;
    return Container(
      margin: const EdgeInsets.all(8),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent
              ? context.theme.primaryColor.withOpacity(0.6)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: ExtendedImage.network(
          model.avatar,
          cache: true,
        ).image,
      ),
    );
  }
}
