import 'package:flutter/material.dart';

void main() {
  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Biodata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menentukan skema warna utama untuk konsistensi
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Biodata Saya",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        // Latar belakang body
        body: Container(
          color: Colors.deepPurple.shade50,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0), // Padding luar untuk jarak dari tepi
          child: Center(
            child: Card(
              elevation: 10, // Menambahkan bayangan untuk efek 3D
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Sudut membulat
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0), // Padding di dalam Card
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Agar Column menyesuaikan konten
                  children: <Widget>[
                    // --- Avatar / Ikon Profil ---
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                      // Jika ada gambar, bisa diganti dengan: backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    const SizedBox(height: 20),

                    // --- Nama ---
                    Text(
                      "Neni Andriana",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurple.shade700,
                        letterSpacing: 1.2, // Jarak antar huruf
                      ),
                    ),
                    const Divider(
                      height: 25,
                      thickness: 2,
                      color: Colors.deepPurpleAccent,
                      indent: 20,
                      endIndent: 20,
                    ),

                    // --- Detail NIM ---
                    _buildDetailRow(
                      icon: Icons.badge,
                      label: "NIM: 701230007",
                    ),
                    const SizedBox(height: 15),

                    // --- Detail Hobi ---
                    _buildDetailRow(
                      icon: Icons.music_note,
                      label: "Hobi: Musik",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi pembangun kustom untuk detail baris (NIM dan Hobi)
  Widget _buildDetailRow({required IconData icon, required String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.deepPurpleAccent,
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}