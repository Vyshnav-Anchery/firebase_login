import 'package:firebase_login/features/login/controller/login_controller.dart';
import 'package:firebase_login/features/signup/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common widgets/custom_textfield.dart';
import '../widgets/password_resetdialogue.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.sizeOf(context).height / 2;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();
    LoginController loginController =
        Provider.of<LoginController>(context, listen: false);
    loginController.isObscure = true;
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Theme.of(context).primaryColor,
            const Color.fromARGB(255, 137, 182, 83),
            Theme.of(context).primaryColor,
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
                          "Login",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "To Your Account",
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
                                        if (value == null || value.isEmpty) {
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
                                    Consumer<LoginController>(
                                      builder: (context, controller, child) {
                                        return CustomTextField(
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
                                          isObscure: controller.isObscure,
                                          onpressed: () =>
                                              controller.toggleVisibility(),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          PasswordResetDialogue());
                                },
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(color: Colors.blue),
                                )),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: cardWidth / 3,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.orangeAccent)),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      loginController.login(
                                          emailEditingController.text,
                                          passwordEditingController.text,
                                          context);
                                    }
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
                                const Text("Dont have an account?"),
                                TextButton(
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen())),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decorationColor: Colors.blue,
                                          decoration: TextDecoration.underline),
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
        ),
      ),
    );
  }
}
