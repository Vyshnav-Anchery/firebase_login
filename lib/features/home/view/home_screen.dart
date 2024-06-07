import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/customAlertDialogue.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context, listen: false);
    final user = homeController.currentUser;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final circleRadius = MediaQuery.sizeOf(context).width / 3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              tooltip: "LogOut",
              onPressed: () => homeController.logOut(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, streamSnapshots) {
            return FutureBuilder(
              future: homeController.getUserDetails(user!.uid),
              builder:
                  (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No user details found'));
                }

                var userDetails = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          // Use Stack to position the edit icon over the avatar
                          children: [
                            if (userDetails['profilePicture'] != null ||
                                userDetails['profilePicture'] == "")
                              CircleAvatar(
                                radius: circleRadius,
                                // backgroundImage:
                                //     NetworkImage(userDetails['profilePicture']),
                                child: ClipOval(
                                  child: Image.network(
                                      userDetails['profilePicture'],
                                      width: circleRadius * 2,
                                      height: circleRadius * 2,
                                      fit: BoxFit.cover, errorBuilder:
                                          (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  }, loadingBuilder:
                                          (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              )
                            else
                              (CircleAvatar(
                                maxRadius: circleRadius,
                                child: Center(
                                  child: Icon(Icons.person, size: circleRadius),
                                ),
                              )),
                            Positioned(
                              // Position the edit icon over the avatar
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton(
                                tooltip: "Edit Image",
                                onPressed: () async {
                                  // final imagePicker = ImagePicker();
                                  // final pickedFile = await imagePicker.pickImage(
                                  //     source: ImageSource.gallery);
                                  // if (pickedFile != null) {
                                  //   // Handle image selection and upload
                                  //   await authController.updateProfilePicture(
                                  //       user.uid, pickedFile.path);
                                  //   // Update the UI with the new profile picture (optional)
                                  // }
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialogue(uid: user.uid);
                                    },
                                  );
                                },
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(fontSize: 30),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              userDetails['username'],
                              style: const TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Text(
                          userDetails['email'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                        const SizedBox(height: 20),

                        if (userDetails['location'] != null)
                          Text(
                              'Location: (${userDetails['location'].latitude}, ${userDetails['location'].longitude})'),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
