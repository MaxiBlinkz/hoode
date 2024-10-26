import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sign_in_controller.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignInPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SignInPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
