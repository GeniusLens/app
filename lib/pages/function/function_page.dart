import 'package:flutter/material.dart';
import 'package:genius_lens/constants.dart';
import 'package:genius_lens/data/debug_model.dart';
import 'package:genius_lens/pages/function/function_card.dart';
import 'package:genius_lens/router.dart';
import 'package:get/get.dart';

class FunctionPage extends StatefulWidget {
  const FunctionPage({super.key});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  List<DebugModel> _debugItems = DebugModel.mocks();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创作'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.globalPadding),
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              _debugItems = DebugModel.mocks();
            });
          },
          child: ListView.builder(
            itemCount: _debugItems.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Get.toNamed(AppRouter.detailPage),
              child: FunctionCard(
                title: _debugItems[index].title,
                description: _debugItems[index].description,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
