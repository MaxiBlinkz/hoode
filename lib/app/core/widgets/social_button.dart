import 'package:flutter/material.dart';
    
class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const SocialButton({ super.key, required this.icon,
  required this.onPressed, });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onPressed,
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          icon,
          width: 30,
          height: 30,
        ),
      ),
    ),
  );
  }
}