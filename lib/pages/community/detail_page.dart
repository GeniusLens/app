import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/request/generate.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';

class CommunityDetailPage extends StatefulWidget {
  const CommunityDetailPage({super.key});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  late final CommunityVO? _content;

  Future<void> _loadFunction() async {
    var f = await GenerateApi.getFunction(1);
    debugPrint('function: $f');
    setState(() {
      _content?.function = f;
    });
  }

  @override
  void initState() {
    super.initState();
    _content = Get.arguments as CommunityVO;
    debugPrint('CommunityDetailPage: $_content');
    setState(() {});
    _loadFunction();
  }

  Widget _buildAppBarHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: ExtendedImage.network(
            _content?.userAvatar ?? DebugUtil.getRandomImageURL(),
            fit: BoxFit.cover,
          ).image,
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _content?.username ?? '用户名',
              style: const TextStyle(fontSize: Constants.captionSize),
            ),
            // const SizedBox(height: 2),
            // Text(
            //   '作品${Random().nextInt(100)}    粉丝${Random().nextInt(100)}',
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: Colors.grey[600],
            //   ),
            // ),
          ],
        ),
        const Spacer(),
        // TextButton(onPressed: () {}, child: const Text('+ 关注')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leadingWidth: 28,
            title: _buildAppBarHeader(),
          ),
          if (_content?.images.isNotEmpty ?? false)
            SliverToBoxAdapter(
              child: Container(
                height: Get.height * 0.618,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Swiper(
                  itemCount: _content?.images.length ?? 0,
                  itemBuilder: (context, index) {
                    return ExtendedImage.network(
                      _content?.images[index] ?? DebugUtil.getRandomImageURL(),
                      fit: BoxFit.cover,
                    );
                  },
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.grey[300],
                      activeColor: context.theme.primaryColor,
                      size: 8,
                      activeSize: 8,
                    ),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _content?.title ?? '标题',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _content?.content ?? '内容',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
          ),
          if (_content?.function != null)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      offset: const Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '同款模板',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _content?.function?.name ?? '功能名称',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: ExtendedImage.network(
                        _content?.images[0] ?? DebugUtil.getRandomImageURL(),
                        fit: BoxFit.cover,
                      ).image,
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    _content?.time ?? '时间',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _content?.likeCount ?? '0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _content?.isLike ?? false
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _content?.isLike ?? false
                        ? Colors.red
                        : Colors.grey[700],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(itemBuilder: (context, index) {
            return const _CommentCard();
          }),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            offset: const Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: ExtendedImage.network(
                  DebugUtil.getRandomImageURL(),
                  fit: BoxFit.cover,
                ).image,
              ),
              const SizedBox(width: 8),
              Text(
                '用户名',
                style: TextStyle(
                  fontSize: Constants.captionSize,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '评论内容',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '时间',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                '点赞数',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.favorite_outline,
                color: Colors.grey[700],
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
