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
  String _buttonText = "Tampilkan Kontak";
  bool _isContactShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Pribadi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/images/foto_neni.jpg"),
                backgroundColor: Colors.deepPurple,
              ),
              const SizedBox(height: 24),

              Text(
                "Neni Andriana",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepPurple.shade900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "Mahasiswa UIN Sultan Thaha Saifuddin Jambi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  height: 1.5,
                ),
              ),

              const Text(
                "Fakultas Sains dan Teknologi, Prodi Sistem Informasi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              const Divider(height: 2, thickness: 1, color: Colors.deepPurpleAccent),
              const SizedBox(height: 24),

              if (_isContactShown)
                const Card(
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "neniandriana.uinstsjambi@gmail.com",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: _isContactShown ? 32 : 12),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isContactShown = !_isContactShown;
                    if (_isContactShown) {
                      _buttonText = "Sembunyikan Kontak";
                    } else {
                      _buttonText = "Tampilkan Kontak";
                    }
                  });

                  // Menambahkan aksi ke konsol
                  print("Aksi: $_buttonText");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Aksi: $_buttonText"),
                      backgroundColor: Colors.deepPurple,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                },
                icon: Icon(
                  _isContactShown ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                label: Text(
                  _buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: const Size(200, 50),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}