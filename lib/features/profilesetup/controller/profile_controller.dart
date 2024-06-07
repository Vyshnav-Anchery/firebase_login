import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';

class ProfileController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserProfile(
      String email, String profilePictureUrl, GeoPoint location) async {
    await _firestore.collection('users').doc(email).update({
      'profilePicture': profilePictureUrl,
      'location': location,
    });
  }

  File? image;
  Position? location;
  late final profilePictureUrl;
  Future<void> pickImage(String email) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // Upload the image to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$email.jpg');
      await ref.putFile(image!);

      // Get the download URL for the image
      String downloadURL = await ref.getDownloadURL();

      profilePictureUrl = downloadURL;
    }
  }

  Future<Position?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled. Request user to enable them.
      return await Geolocator.requestPermission().then((value) {
        if (value == LocationPermission.whileInUse ||
            value == LocationPermission.always) {
          return getLocation(); // Call again if permission is granted
        } else {
          AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
              const SnackBar(content: Text("Please turn on gps")));
          return getLocation(); // Handle permission denied or error
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
      // Explanation for denied forever (optional)
      print(
          'Location permissions are permanently denied. Please go to Settings to enable them.');
      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
          content: Text(
              "Location permissions are permanently denied. Please go to Settings to enable them.")));
      return null;
    }

    // Get the current location with desired accuracy

    location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
