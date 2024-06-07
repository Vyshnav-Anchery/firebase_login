import 'package:firebase_login/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAlertDialogue extends StatelessWidget {
  final String uid;
  const CustomAlertDialogue({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController =
        Provider.of<HomeController>(context, listen: false);
    return AlertDialog(
      title: const Text("Edit image"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<HomeController>(
            builder: (context, controller, child) {
              if (controller.image == null) {
                return const SizedBox(
                  height: 300,
                  width: 300,
                  child: Icon(Icons.image_sharp, size: 200),
                );
              } else {
                return SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.file(controller.image!),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => homeController.pickImage(),
              child: const Text("Select Image"))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => homeController.deleteImage(uid, context),
            child: const Text("Delete")),
        TextButton(
            onPressed: () => homeController.updateUserImage(uid, context),
            child: const Text("Update"))
      ],
    );
  }
}
