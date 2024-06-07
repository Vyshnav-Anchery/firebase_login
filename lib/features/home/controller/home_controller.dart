// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/features/login/view/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';

class HomeController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profilePictureUrl = "";
  File? image;

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  logOut(BuildContext context) async {
    _auth.signOut().whenComplete(() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        )));
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> updateUserImage(String uid, BuildContext context) async {
    if (image != null) {
      // Upload the image to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      await ref.putFile(image!);

      // Get the download URL for the image
      String downloadURL = await ref.getDownloadURL();

      profilePictureUrl = downloadURL;
      await _firestore.collection('users').doc(uid).update({
        'profilePicture': profilePictureUrl,
      }).whenComplete(() => Navigator.pop(context));
    } else {
      Navigator.pop(context);
      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Please Select an Image to update')),
      );
    }
  }

  Future<void> deleteImage(String uid, BuildContext context) async {
    try {
      // reference to the image file
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference imageRef = storage.ref().child("profile_pictures/$uid.jpg");

      // Delete the image from storage
      await imageRef.delete();
      // Delete the image url from firebase
      await _firestore.collection('users').doc(uid).update({
        'profilePicture': "",
      }).whenComplete(() => Navigator.pop(context));

      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Image deleted')),
      );
    } catch (e) {
      Navigator.pop(context);
      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Please try again later...')),
      );
      log("Error occurred while deleting image: $e");
    }
  }
}
