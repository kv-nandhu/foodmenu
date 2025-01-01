import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodmenu/home_screen/home_screen.dart';
import 'package:foodmenu/home_screen/provider/provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // Generated file from `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Menu Admin',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AdminPage(),
      ),
    );
  }
}
