import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // BANNER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Hoode")],
              ),

              // SIGN UP
              Container(
                height: 400,
                width: 350,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 226, 227),
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    // EMAIL
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            height: 24,
                            width: 6,
                            color: AppColors.primary),
                            SizedBox(width: 40),
                          Text("Email",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: emailController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Enter Email or Username"
                            )
                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // PASSWORD
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            height: 24,
                            width: 6,
                            color: AppColors.primary),
                            SizedBox(width: 40),
                          Text("Password",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: passwordController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Enter Password"
                            )
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
