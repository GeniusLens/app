import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/request/community.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/provider/community_provider.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatefulWidget {
  const CommunityDetailPage({super.key});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  CommunityVO? _content;
  final List<CommentVO> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  Future<void> _loadData() async {
    var result = await CommunityApi().getComments(_content!.id);
    if (mounted) {
      setState(() {
        _comments.clear();
        _comments.addAll(result);
      });
    }
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _content = context.read<CommunityProvider>().community;
      print(_content);
      _loadData();
    });
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: context.theme.cardColor,
              child: Text(
                _content?.title ?? '标题',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: context.theme.cardColor,
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
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '评论',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          SliverList.builder(
              itemCount: _comments.length + 1,
              itemBuilder: (context, index) {
                if (index == _comments.length) {
                  return Container(
                    margin:
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
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: ExtendedImage.network(
                              DebugUtil.getRandomImageURL(),
                              fit: BoxFit.cover,
                            ).image,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: '写评论...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  );
                }
                return _CommentCard(comment: _comments[index]);
              }),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({super.key, required this.comment});

  final CommentVO comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
                  comment.userAvatar ?? DebugUtil.getRandomImageURL(),
                  fit: BoxFit.cover,
                ).image,
              ),
              const SizedBox(width: 8),
              Text(
                comment.userName ?? '用户名',
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
            comment.content ?? '评论内容',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                comment.time ?? '时间',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                comment.likeCount?.toString() ?? '0',
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
