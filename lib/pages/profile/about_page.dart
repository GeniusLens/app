import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:genius_lens/utils/package_util.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 172,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 32),
              child: Image(
                image: ExtendedImage.network(
                  'https://image.thuray.xyz/2024/03/4a3a3d3b575c63d957c944a5fd9f421a.png',
                  width: 172,
                  height: 172,
                  fit: BoxFit.fill,
                ).image,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Life In Portrai',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: context.theme.primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'v${PackageUtil().version}' ?? '',
              style: TextStyle(
                fontSize: 16,
                color: context.theme.primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '关于我们',
              style: TextStyle(
                fontSize: 18,
                color: context.theme.primaryColor.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
