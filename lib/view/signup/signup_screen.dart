import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/common widgets/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.sizeOf(context).height / 2;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();
    TextEditingController confirmEditingController = TextEditingController();
    bool isObscure = false;
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, controller, child) {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color(0xFF76984C),
                Color.fromARGB(255, 137, 182, 83),
                Color(0xFF76984C),
              ])),
              child: Center(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height / 3,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SignUp",
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Create your Account",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              )),
                          width: cardWidth,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        CustomTextField(
                                          hintText: "Email",
                                          validator: (value) {
                                            const String emailPattern =
                                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter an email';
                                            }
                                            RegExp regex = RegExp(emailPattern);
                                            if (!regex.hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                          textEditingController:
                                              emailEditingController,
                                          isObscure: false,
                                          isPassword: false,
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          hintText: "Password",
                                          validator: (value) {
                                            const String passwordPattern =
                                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$';
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a password';
                                            }
                                            if (value.length < 8) {
                                              return 'Password must be at least 8 characters long';
                                            }
                                            RegExp regex =
                                                RegExp(passwordPattern);
                                            if (!regex.hasMatch(value)) {
                                              return 'Password must include an uppercase letter, number, and a special character';
                                            }
                                            return null;
                                          },
                                          textEditingController:
                                              passwordEditingController,
                                          isPassword: true,
                                          isObscure: isObscure,
                                          onpressed: () {},
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          hintText: "Confirm Password",
                                          validator: (value) {
                                            if (value !=
                                                passwordEditingController
                                                    .text) {
                                              return 'Both passwords must be same';
                                            }
                                            return null;
                                          },
                                          textEditingController:
                                              confirmEditingController,
                                          isPassword: true,
                                          isObscure: isObscure,
                                          onpressed: () {},
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          hintText: "Confirm Password",
                                          validator: (value) {
                                            if (value !=
                                                passwordEditingController
                                                    .text) {
                                              return 'Both passwords must be same';
                                            }
                                            return null;
                                          },
                                          textEditingController:
                                              confirmEditingController,
                                          isPassword: true,
                                          isObscure: isObscure,
                                          onpressed: () {},
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    )),
                                SizedBox(
                                  width: cardWidth / 3,
                                  child: ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.orangeAccent)),
                                      onPressed: () {
                                        formKey.currentState!.validate();
                                      },
                                      child: const Text(
                                        "Log In",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Already have an account?"),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decorationColor: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
