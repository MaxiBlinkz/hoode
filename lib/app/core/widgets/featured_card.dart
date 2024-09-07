import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        color: const Color.fromARGB(153, 205, 208, 255),
        child: Row(
          children: [
            Image.asset(
              Assets.images.house2.path,
              fit: BoxFit.cover,
              width: 200,
              height: double.infinity,
            ),
          ],
        ));
  }
}
