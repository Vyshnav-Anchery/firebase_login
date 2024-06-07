import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmail(String email, String pass) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      return credential.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String pass) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
                content: Text("Invalid email. Please check and try again.")));
      } else if (e.code == 'wrong-password') {
        AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
                content: Text("Incorrect password. Please try again.")));
      } else if (e.code == 'invalid-credential') {
        AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
                content: Text("Incorrect email or password please try again")));
      } else {
        // Handle other Firebase errors (optional)
        log(e.toString());
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  passReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
