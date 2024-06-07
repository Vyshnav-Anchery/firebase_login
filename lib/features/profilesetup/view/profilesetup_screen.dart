import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/features/profilesetup/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String email;

  const ProfileSetupScreen({required this.email});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late ProfileController profileController;

  @override
  void initState() {
    profileController = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              profileController.image == null
                  ? const Text('No image selected.')
                  : Image.file(profileController.image!),
              ElevatedButton(
                onPressed: () => profileController.pickImage(widget.email),
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
                onPressed: () async {
                  if (profileController.image != null &&
                      profileController.location != null) {
                    // Upload the image to a storage solution (e.g., Firebase Storage) and get the URL
                    String profilePictureUrl =
                        "uploaded_image_url"; // Replace with actual upload code

                    await profileController.updateUserProfile(
                      widget.email,
                      profilePictureUrl,
                      GeoPoint(profileController.location!.latitude,
                          profileController.location!.longitude),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile setup complete')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please complete all fields')),
                    );
                  }
                },
                child: const Text('Complete Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
