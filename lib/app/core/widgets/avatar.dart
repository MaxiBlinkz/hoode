import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String image_url;
  final String initials;

  Avatar({
    super.key,
    required this.image_url,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue,
      backgroundImage: image_url.isNotEmpty ? AssetImage(image_url) : null,
      child: image_url.isEmpty
          ? Text(initials, style: TextStyle(fontSize: 40, color: Colors.white))
          : null,
    );
  }
}
