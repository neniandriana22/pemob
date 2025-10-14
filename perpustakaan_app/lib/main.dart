// File: lib/main.dart
import 'package:flutter/material.dart';
import 'ui/mahasiswa_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Perpustakaan',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
        ),
      ),
      home: const MahasiswaPage(),
    );
  }
}