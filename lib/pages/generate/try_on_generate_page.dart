import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/common.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/data/entity/common.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TryOnGeneratePage extends StatefulWidget {
  const TryOnGeneratePage({super.key});

  @override
  State<TryOnGeneratePage> createState() => _TryOnGeneratePageState();
}

class _TryOnGeneratePageState extends State<TryOnGeneratePage> {
  final GlobalKey _panelKey = GlobalKey();
  final List<String> _images = [
    "https://integrity-backend.sduonline.cn/files/d7d1887a-e1ff-419c-91a3-b4c36e1fb2e9.jpg"
  ];
  final List<ClothVO> _clothes = [];

  int _selected = -1;

  Future<void> _loadClothes() async {
    var data = await CommonAPi.getClothes();
    setState(() {
      _clothes.clear();
      _clothes.addAll(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              var result = GenerateApi.submitTask();
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
              child: const Text(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                _selected = _clothes.length - 1;
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
                            if (_selected == index) {
                              _selected = -1;
                            } else {
                              _selected = index;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: (_selected == index)
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
          body: Container(
            margin: const EdgeInsets.only(bottom: 300),
            child: Swiper(
              itemCount: _images.length,
              loop: false,
              scale: 0.8,
              viewportFraction: 0.7,
              pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Colors.grey[300]!,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.theme.cardColor,
                    border: (index == 0)
                        ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
