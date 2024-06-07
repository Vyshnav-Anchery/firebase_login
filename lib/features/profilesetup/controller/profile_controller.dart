import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../home/view/home_screen.dart';

class ProfileController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String profilePictureUrl = "";
  File? image;
  Position? location;

  Future<void> updateUserProfile(
      String email, String uid, BuildContext context) async {
    if (image != null && location != null) {
      // add profile pic and location to firestore
      await _firestore.collection('users').doc(uid).update({
        'profilePicture': profilePictureUrl,
        'location': GeoPoint(location!.latitude, location!.longitude),
      }).whenComplete(() => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          )));
    } else {
      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  Future<void> pickImage(String uid) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // Upload the image to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      await ref.putFile(image!);

      // Get the download URL for the image
      String downloadURL = await ref.getDownloadURL();

      profilePictureUrl = downloadURL;
      notifyListeners();
    }
  }

  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await Geolocator.requestPermission().then((value) {
        if (value == LocationPermission.whileInUse ||
            value == LocationPermission.always) {
          return getLocation();
        } else {
          AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
              const SnackBar(content: Text("Please turn on gps")));
          return getLocation();
        }
      });
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("Please enable location permission")));
        return getLocation();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied. Please go to Settings to enable them.');
      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
          content: Text(
              "Location permissions are permanently denied. Please go to Settings to enable them.")));
      return null;
    }
    location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    notifyListeners();
  }
}
