import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'messages_controller.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessagesPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MessagesPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
