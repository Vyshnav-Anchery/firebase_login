import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/core/utils/firebaseauth_impl.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  signUp(String email, String pass, String uName) async {
    User? userCred = await firebaseAuthService.signUpWithEmail(email, pass);
    if (userCred != null) {
      log("created");
    } else {
      log("not done");
    }
  }
}
