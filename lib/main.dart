import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/features/home/controller/home_controller.dart';
import 'package:firebase_login/features/signup/controller/signup_controller.dart';
import 'package:firebase_login/core/constants/app_constants.dart';
import 'package:firebase_login/features/signup/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/login/controller/login_controller.dart';
import 'core/utils/firebase_options.dart';
import 'features/login/view/login_screen.dart';
import 'features/profilesetup/controller/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => SignupController(),
    ),
    ChangeNotifierProvider(
      create: (context) => LoginController(),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeController(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProfileController(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: AppConstants.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}
