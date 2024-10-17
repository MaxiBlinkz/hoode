// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hoode/app/core/theme/colors.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: AppColors.primary,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }
}
