import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/data/entity/generate.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

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
  final List<CategoryVO> _subCategories = [];
  int _selectedIndex = 0;
  bool _isLoading = false;

  Future<void> _loadCategory() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    var list = await GenerateApi.getCategoryList();
    _categories.addAll(list);
    print("Loading category: $list");

    setState(() {
      _tabController = TabController(length: _categories.length, vsync: this)
        ..addListener(() {
          // 监听Tab切换
          if (_tabController.indexIsChanging) {
            return;
          } else {
            print("Tab index: ${_tabController.index}");
            print("Tab name: ${_categories[_tabController.index].name}");
            _loadSubCategory(_categories[_tabController.index].name);
          }
        });
      _isLoading = false;
    });
    _loadSubCategory(_categories[0].name);
    _tabController.animateTo(0);
    _tabController.index = 0;
  }

  Future<void> _loadSubCategory(String category) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    var list = await GenerateApi.getSubCategoryList(category);
    print("Loading sub category: $list");
    setState(() {
      _subCategories.clear();
      _subCategories.addAll(list);
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
          children: _categories
              .map((e) => _GenerateList(subCategories: _subCategories))
              .toList(),
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

class _GenerateListState extends State<_GenerateList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.subCategories.length,
        itemBuilder: (context, index) {
          return _GenerateItem(item: widget.subCategories[index]);
        });
  }
}

class _GenerateItem extends StatelessWidget {
  const _GenerateItem({super.key, required this.item});

  final CategoryVO item;

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
                    } else if (state.extendedImageLoadState == LoadState.failed) {
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
                        Text(item.name, style: const TextStyle(fontSize: 18)),
                        Text(
                          "${item.description}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Get.toNamed(AppRouter.selectModelPage, arguments: item),
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
