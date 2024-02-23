import 'package:flutter/material.dart';
import 'package:test1/pages/Auth/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontFamily: 'MyUniqueFont',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            displayMedium: TextStyle(
                fontFamily: 'MyUniqueFont',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
