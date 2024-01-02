import 'package:flutter/material.dart';

class DetailCopyright extends StatelessWidget {
  const DetailCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        // 添加开源的授权信息
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Powered by ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Genius Lens',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2023 Genius Lens',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
