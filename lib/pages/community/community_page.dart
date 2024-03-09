import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:genius_lens/api/request/community.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/pages/community/community_card.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EEE {
  String url;
  String? title;

  EEE(this.url, this.title);
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  final double _basicWidth = Get.width * 0.618 - 24;

  int _selectedIndex = 0;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final List<CommunityVO> _list = [];
  bool _isLoading = false;

  final ScrollController _scrollController = ScrollController();

  void _playAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _loadData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    var list = await CommunityApi().getCommunityRecommendList();
    debugPrint('item count: ${list.length}');
    debugPrint(list.toString());
    setState(() => _list.addAll(list));
  }

  Future<void> _refreshData() async {
    setState(() => _list.clear());
    await _loadData();
  }

  void _onLike(int index) {
    setState(() {
      _list[index].isLike = !_list[index].isLike;
    });
  }

  Widget _buildBarText(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        _animationController.reset();
        _playAnimation();
        _refreshData();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _selectedIndex == index ? _animation.value : 1.0,
              child: Text(
                text,
                style: TextStyle(
                  color: _selectedIndex == index
                      ? Colors.grey[900]
                      : Colors.grey[600],
                  fontSize: Constants.subtitleSize,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
    _animationController.forward();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData();
      }
    });

    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBarText('推荐', 0),
            _buildBarText('热门', 1),
          ],
        ),
        actions: const [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.search),
          // ),
        ],
      ),
      body: (_isLoading)
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: context.theme.primaryColor,
                size: 36,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.globalPadding),
                child: (_list.isNotEmpty)
                    ? MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemCount: _list.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          var item = _list[index];
                          var height =
                              _basicWidth + 32 * (item.cardHeight ?? 2);
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed('/community/detail', arguments: item);
                            },
                            child: SizedBox(
                              height: height,
                              child: CommunityCard(item, () => _onLike(index)),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 36,
                              color: context.theme.primaryColor,
                            ),
                            const SizedBox(height: 16),
                            const Text('暂无数据'),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }
}
