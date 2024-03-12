import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../api/request/generate.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<CategoryVO> _categories = [];
  final Map<String, List<CategoryVO>> _subCategories = {};
  bool _isLoading = false;

  Future<void> _loadCategory() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    var list = await GenerateApi.getCategoryList();
    _categories.addAll(list);
    for (var element in _categories) {
      _subCategories[element.name] = [];
    }

    setState(() {
      _tabController = TabController(length: _categories.length, vsync: this)
        ..addListener(() {
          // 监听Tab切换
          if (_tabController.indexIsChanging) {
            return;
          }
          _loadSubCategory(_categories[_tabController.index].name);
        });
      _isLoading = false;
    });
    _loadSubCategory(_categories[0].name);
    _tabController.animateTo(0);
    _tabController.index = 0;
  }

  Future<void> _loadSubCategory(String category) async {
    if (_isLoading) return;
    if (_subCategories[category]!.isNotEmpty) return;
    setState(() {
      _isLoading = true;
    });

    var list = await GenerateApi.getSubCategoryList(category);
    setState(() {
      if (list.isNotEmpty) {
        _subCategories[category] = list;
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _loadCategory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: (_categories.isEmpty)
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                tabAlignment: TabAlignment.start,
                tabs: _categories.map((e) => Tab(text: e.name)).toList(),
              ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadCategory,
        child: TabBarView(
          controller: _tabController,
          children: _categories.map((e) {
            if (_subCategories[e.name] == null ||
                _subCategories[e.name]!.isEmpty) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: context.theme.primaryColor,
                  size: 36,
                ),
              );
            }
            return _GenerateList(
                subCategories: _subCategories[e.name] ?? [],
                key: ValueKey(e.name));
          }).toList(),
        ),
      ),
    );
  }
}

class _GenerateList extends StatefulWidget {
  const _GenerateList({super.key, required this.subCategories});

  final List<CategoryVO> subCategories;

  @override
  State<_GenerateList> createState() => _GenerateListState();
}

class _GenerateListState extends State<_GenerateList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? _buildRoute(CategoryVO item) {
    if (item.name == "AI变身") {
      return AppRouter.videoGeneratePage;
    }
    if (item.name == "换装") {
      return AppRouter.tryOnGeneratePage;
    }
    if (item.name == "穿搭建议") {
      return AppRouter.wearEvaluatePage;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimationLimiter(
      child: ListView.builder(
          itemCount: widget.subCategories.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.subCategories.length) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: Text(
                    '已经到底部啦',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                delay: Duration(milliseconds: 10 * index),
                child: FadeInAnimation(
                  child: _GenerateItem(
                    item: widget.subCategories[index],
                    route: _buildRoute(widget.subCategories[index]),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class _GenerateItem extends StatelessWidget {
  const _GenerateItem({super.key, required this.item, this.route});

  final CategoryVO item;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256 + 64,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ExtendedImage.network(
                  item.cover ?? "https://via.placeholder.com/150",
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.extendedImageLoadState ==
                        LoadState.failed) {
                      return const Center(
                        child: Icon(Icons.error),
                      );
                    }
                    return null;
                  },
                  cache: true,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 16)),
                        Text(
                          "${item.description}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(
                    route ?? AppRouter.selectModelPage,
                    arguments: item,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "马上制作",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
