import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool? isPassword;
  final bool? isObscure;
  final String hintText;
  final Function()? onpressed;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.onpressed,
      this.isObscure = true,
      this.isPassword = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure!,
      controller: textEditingController,
      validator: validator,
      decoration: InputDecoration(
          errorMaxLines: 2,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          hintText: hintText,
          suffixIcon: isPassword!
              ? IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: onpressed,
                  icon: isObscure!
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility))
              : const SizedBox()),
    );
  }
}
