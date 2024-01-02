import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/pages/detail/detail_copyright.dart';
import 'package:genius_lens/pages/detail/detail_intro.dart';
import 'package:genius_lens/pages/detail/detail_sharing_card.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final double _imageHeight = 512;
  bool _showFab = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      debugPrint(_scrollController.offset.toString());
      if (_scrollController.offset > _imageHeight / 3) {
        if (!_showFab) {
          setState(() => _showFab = true);
        }
      } else {
        if (_showFab) {
          setState(() => _showFab = false);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 展示fab，用于快速体验该页面对应的功能
      floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              onPressed: () {
                Get.snackbar('提示', '该功能正在开发中');
              },
              label: const Text('现在体验'),
              icon: const Icon(Icons.play_arrow),
            )
          : null,
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          thickness: 4,
          trackVisibility: true,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                title: const Text('单人写真'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  height: _imageHeight,
                  child: Swiper(
                    itemCount: 3,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        size: 8,
                        activeColor: Colors.white,
                        color: Colors.grey,
                      ),
                    ),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: ExtendedImage.network(
                            'https://s2.loli.net/2024/01/02/X7DU1cpKtfujg5o.png',
                            fit: BoxFit.cover,
                            cache: true,
                            key: Key(DebugUtil.getRandomImageURL()),
                          ).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Constants.globalPadding),
                  child: DetailIntro(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Constants.globalPadding),
                  child: DetailSharingCard(),
                ),
              ),
              const SliverToBoxAdapter(
                child: DetailCopyright(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
