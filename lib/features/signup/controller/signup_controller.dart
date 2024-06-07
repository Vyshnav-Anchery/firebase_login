import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/core/utils/firebaseauth_impl.dart';
import 'package:firebase_login/features/profilesetup/view/profilesetup_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SignupController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  User? get currentUser => _auth.currentUser;

  signUp(
      String email, String pass, String username, BuildContext context) async {
    User? userDetails = await _firebaseAuthService.signUpWithEmail(email, pass);
    // UserCredential userCredential =
    //     await _auth.createUserWithEmailAndPassword(
    //   email: email,
    //   password: pass,
    // );
    if (userDetails != null) {
      log(userDetails.uid);
      await _firestore.collection('users').doc(userDetails.uid).set({
        'username': username,
        'email': email,
      }).whenComplete(() => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileSetupScreen(
              email: email,
              uid: userDetails.uid,
            ),
          )));
    }
  }

  Future<void> updateUserProfile(
      String email, String profilePictureUrl, Position location) async {
    await _firestore.collection('users').doc(email).update({
      'profilePicture': profilePictureUrl,
      'location': location,
    });
  }
}
