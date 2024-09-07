import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_remix/flutter_remix.dart';

//import '../../../gen/assets.gen.dart';
import '../../core/theme/colors.dart';
//import '../../core/widgets/featured_card.dart';


class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12))),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Hi, Maxi",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              //alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                FlutterRemix.compass_discover_fill,
                color: Colors.white,
              ),
              iconSize: 24.0,
              onPressed: () {},
            ).paddingZero,
            IconButton(
              //alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                FlutterRemix.notification_2_fill,
                color: Colors.white,
              ),
              iconSize: 20.0,
              onPressed: () {},
            ),
          ],
        ),
        Container(
          height: 40,
          width: 280,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)),
        )
      ]),
    );
  }
}

