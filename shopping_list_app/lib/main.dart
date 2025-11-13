// File: lib/main.dart

import 'package:flutter/material.dart';
// UBAH BARIS INI: Ganti 'your_app_name' dengan 'shopping_list_app'
import 'package:shopping_list_app/shopping_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const ShoppingListScreen(),
    );
  }
}