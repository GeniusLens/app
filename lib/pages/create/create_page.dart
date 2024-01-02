import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建分身'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Swiper(
              itemCount: 4,
              transformer: ScaleAndFadeTransformer(),
              scale: 0.9,
              fade: 0.5,
              viewportFraction: 0.8,
              pagination: const SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  color: Colors.grey,
                  activeColor: Colors.white,
                  size: 8,
                  activeSize: 12,
                ),
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: ExtendedImage.network(
                        (index == 0)
                            ? 'https://s2.loli.net/2024/01/02/Lx5QobdyECN2YDc.png'
                            : DebugUtil.getRandomImageURL(),
                        fit: BoxFit.cover,
                      ).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: (index == 0)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 348),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                              const Text(
                                '点击创建',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     minimumSize: Size(Get.width * 0.618, 48),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //   ),
          //   child: const Text('创建'),
          // ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
