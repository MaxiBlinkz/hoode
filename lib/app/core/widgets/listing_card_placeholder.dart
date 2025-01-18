import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Example Placeholder - Adjust to match ListingCard structure
class ListingCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        child: Container(
      width: 180, // replace with a value you deem fit
      height: 200, // replace with a value you deem fit
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    ));
  }
}
