import 'package:firebase_login/features/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common widgets/custom_textfield.dart';

class PasswordResetDialogue extends StatelessWidget {
  const PasswordResetDialogue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController resetemailEditingController = TextEditingController();
    LoginController loginController =
        Provider.of<LoginController>(context, listen: false);
    return AlertDialog(
      title: const Text("Reset Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter email to send password reset link"),
          const SizedBox(height: 20),
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
            textEditingController: resetemailEditingController,
            isObscure: false,
            isPassword: false,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        TextButton(
            onPressed: () {
              loginController.resetPassword(
                  context, resetemailEditingController.text);
            },
            child: Text("Send Email")),
      ],
    );
  }
}
