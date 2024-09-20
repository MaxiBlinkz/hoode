import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children: [
            // BANNER
            Row(
              children: [
                Text("Hoode")
              ],
            ),

            // SIGN UP
            Container(
              height: 300,
              width: 400,
              child: Column(
                children: [
                  Text("Email"),
                  Container(),
                  Text("Password"),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
