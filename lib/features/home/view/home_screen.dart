import 'package:firebase_login/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<HomeController>(context, listen: false);
    final user = authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder(
        future: authController.getUserDetails(user!.email!),
        builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user details found'));
          }

          var userDetails = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userDetails['profilePicture'] != null)
                  Image.network(userDetails['profilePicture']),
                Text('Username: ${userDetails['username']}'),
                Text('Email: ${userDetails['email']}'),
                if (userDetails['location'] != null)
                  Text(
                      'Location: (${userDetails['location'].latitude}, ${userDetails['location'].longitude})'),
              ],
            ),
          );
        },
      ),
    );
  }
}
