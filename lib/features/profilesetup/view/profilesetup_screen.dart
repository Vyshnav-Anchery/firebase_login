import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/features/home/view/home_screen.dart';
import 'package:firebase_login/features/profilesetup/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatelessWidget {
  final String email;
  final String uid;
  const ProfileSetupScreen({super.key, required this.email, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Setup',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileController.image == null
                        ? Container(
                            height: 400,
                            width: 300,
                            color: Colors.amber,
                          )
                        : SizedBox(
                            height: 400,
                            width: 300,
                            child: Image.file(profileController.image!)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => profileController.pickImage(uid),
                      child: const Text('Pick Profile Picture'),
                    ),
                    const SizedBox(height: 20),
                    profileController.location == null
                        ? const Text('No location selected.')
                        : Text(
                            'Location: ${profileController.location!.latitude}, ${profileController.location!.longitude}'),
                    ElevatedButton(
                      onPressed: () => profileController.getLocation(),
                      child: const Text('Get Location'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => profileController.updateUserProfile(
                          email, uid, context),
                      child: const Text('Complete Setup'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
