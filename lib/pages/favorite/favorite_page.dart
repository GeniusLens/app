import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/api/favorite.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/entity/favorite.dart';
import 'package:genius_lens/pages/favorite/favorite_card.dart';
import 'package:genius_lens/utils/debug_util.dart';
import 'package:get/get.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<FavoriteEntity> _list = [];
  bool _hasError = false;
  bool _isLoading = false;

  Future<void> _loadData() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _list.clear();
    });
    try {
      var list = await FavoriteApi().getFavoriteList();
      setState(() {
        _list.addAll(list);
        _hasError = false;
      });
    } catch (e) {
      Get.snackbar('加载失败', e.toString());
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.globalPadding),
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('收藏'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
                // 在App Bar底部扩展空间显示搜索框
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      isDense: true,
                      constraints: const BoxConstraints(maxHeight: 48),
                      hintText: '搜索收藏',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              // 占位符
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              if (_hasError)
                SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh, size: 36),
                        ),
                        const Text('加载失败, 请重试', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_list.isNotEmpty && !_isLoading && !_hasError)
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return FavoriteCard(
                      _list[index],
                    );
                  },
                  itemCount: _list.length,
                ),
              // 占位符
              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
