import 'package:flutter/material.dart';
// Perbaiki path import agar menunjuk ke 'pages/dosen_list_page.dart'
import 'pages/dosen_list_page.dart';

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen App',
      // Menetapkan tema yang konsisten
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white), // Ikon appbar putih
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      // Menetapkan DosenListPage sebagai halaman awal
      home: const DosenListPage(),
    );
  }
}