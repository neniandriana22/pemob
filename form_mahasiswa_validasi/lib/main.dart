import 'package:flutter/material.dart';
import 'form_page.dart'; // Pastikan baris ini ada untuk memanggil file form_page.dart

// --- INI ADALAH FUNGSI MAIN YANG HILANG ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Opsional: Menghilangkan banner debug
      title: 'Form Mahasiswa Validasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Memanggil halaman FormPage sebagai halaman utama
      home: const FormPage(),
    );
  }
}