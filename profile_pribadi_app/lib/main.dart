import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Pribadi Neni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Inter',
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State untuk mengontrol tampilan kontak
  bool _isContactShown = false;

  // Data detail kontak
  final List<Map<String, dynamic>> _contactDetails = [
    {
      'icon': Icons.email,
      'label': "Email",
      'value': "neniandriana.uinstsjambi@gmail.com",
    },
    {
      'icon': Icons.phone,
      'label': "Telepon",
      'value': "+62 831-7047-9069",
    },
    {
      'icon': Icons.person_pin,
      'label': "Instagram",
      'value': "@neniandriana_",
    },
  ];

  void _toggleContact() {
    setState(() {
      _isContactShown = !_isContactShown;
    });

    String actionText = _isContactShown ? "Menampilkan Kontak" : "Menyembunyikan Kontak";

    // Aksi di Konsol (Kualifikasi Tugas Terpenuhi)
    print("Aksi Tombol: $actionText");

    // Aksi menggunakan SnackBar (Kualifikasi Tugas Terpenuhi)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(actionText),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  // Widget untuk menampilkan satu baris detail kontak (ListTile yang dirapikan)
  Widget _buildContactRow(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      leading: Icon(icon, color: Colors.deepPurple, size: 28),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    String buttonText = _isContactShown ? "Sembunyikan Detail" : "Tampilkan Detail Kontak";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Pribadi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =================================================================
            // 1 & 2. Card Header Profil (FOTO dan NAMA) - UNGU SOFT & RAPIH
            // =================================================================
            Card(
              elevation: 10,
              color: Colors.deepPurple.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Foto Profil (CircleAvatar)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(51, 0, 0, 0),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/images/foto_neni.jpg"),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Nama Lengkap
                    Text(
                      "Neni Andriana",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurple.shade900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // MENGURANGI JARAK: DARI 25 MENJADI 15
            const SizedBox(height: 15),

            // =================================================================
            // 3. Card Deskripsi Singkat Diri
            // =================================================================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tentang Saya:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    // KODE DIVIDER SUDAH BENAR
                    const Divider(color: Colors.deepPurpleAccent, height: 20, thickness: 1.5),

                    const Text(
                      "Mahasiswa UIN Sultan Thaha Saifuddin Jambi",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      "Saya Neni Andriana, Mahasiswi SI yang bersemangat dalam Mobile Development. Saya menciptakan aplikasi yang fungsional dan rapi menggunakan Flutter. Membangun masa depan, satu kode per satu.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // MENGURANGI JARAK: DARI 25 MENJADI 15
            const SizedBox(height: 15),

            // =================================================================
            // Bagian Kontak (Conditional Rendering)
            // =================================================================
            if (_isContactShown)
              Card(
                elevation: 4,
                // PERBAIKAN DILAKUKAN DI SINI:
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  // MENGHAPUS PARAMETER 'color' YANG TIDAK ADA
                ),
                color: Colors.deepPurple.shade50, // MENGGUNAKAN PROPERTI 'color' DI LUAR 'shape'
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        "Informasi Kontak",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    ..._contactDetails
                        .map((contact) => _buildContactRow(
                      contact['icon'] as IconData,
                      contact['label'] as String,
                      contact['value'] as String,
                    ))
                        .toList(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

            // MENGURANGI JARAK: Disesuaikan agar tombol lebih dekat dengan Card terakhir
            SizedBox(height: _isContactShown ? 20 : 15),

            // =================================================================
            // 4. Tombol dengan Aksi
            // =================================================================
            ElevatedButton.icon(
              onPressed: _toggleContact,
              icon: Icon(
                _isContactShown ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
              label: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 55),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}