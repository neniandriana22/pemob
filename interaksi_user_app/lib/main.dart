// lib/main.dart

import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// BAGIAN 1: Struktur Dasar Aplikasi & Tema
// -----------------------------------------------------------------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interaksi User App',
      debugShowCheckedModeBanner: false,
      // ✨ Tema (ThemeData) untuk tampilan profesional
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        useMaterial3: true,
      ),
      home: const BiodataFormPage(),
    );
  }
}

// -----------------------------------------------------------------------------
// BAGIAN 2: StatefulWidget
// -----------------------------------------------------------------------------

// Enum untuk memudahkan pengelolaan jenis kelamin
enum JenisKelamin { pria, wanita }

class BiodataFormPage extends StatefulWidget {
  const BiodataFormPage({super.key});

  @override
  State<BiodataFormPage> createState() => _BiodataFormPageState();
}

class _BiodataFormPageState extends State<BiodataFormPage> {
  // -----------------------------------------------------------------------------
  // BAGIAN 3: Variabel State
  // -----------------------------------------------------------------------------
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  JenisKelamin? _jenisKelaminSaatIni;
  Map<String, bool> _hobiStatus = {
    'Coding': false,
    'Membaca': false,
    'Olahraga': false,
    'Traveling': false,
  };
  String _hasilInput = "Tekan 'Simpan' untuk melihat hasil input.";

  // -----------------------------------------------------------------------------
  // BAGIAN 4: Fungsi untuk Mengelola Interaksi
  // -----------------------------------------------------------------------------
  void _simpanData() {
    // Memperbarui state hanya untuk memicu UI rebuild
    setState(() {
      // Kita tidak perlu lagi membangun string panjang di sini,
      // karena kita akan membangun tampilan hasil yang terstruktur
      // langsung dari Controller dan State.
      _hasilInput = "Data telah diperbarui."; // Pesan placeholder baru
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------------------
  // BAGIAN 5: UI (Tampilan) Aplikasi
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Formulir Interaktif",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Card Form Input
            _buildInputFormCard(context),

            const SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _simpanData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                elevation: 5,
              ),
              child: const Text("Simpan Biodata"),
            ),

            const Divider(height: 40, thickness: 1.5, color: Colors.grey),

            // Card Hasil Input (Tampilan yang sudah diperbaiki)
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu: Card untuk Form Input
  Widget _buildInputFormCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Lengkapi Biodata Anda:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.indigo),
            ),
            const SizedBox(height: 20),

            // 1. Input Nama (TextField)
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Input Umur (TextField)
            TextField(
              controller: _umurController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Umur",
                prefixIcon: Icon(Icons.cake_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Jenis Kelamin (Radio Button)
            const Text("Jenis Kelamin:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            _buildRadioOptions(),
            const SizedBox(height: 12),

            // 4. Hobi (Checkbox)
            const Text("Hobi:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            ..._buildCheckboxList(),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu: Radio Button
  Widget _buildRadioOptions() {
    return Column(
      children: [
        RadioListTile<JenisKelamin>(
          title: const Text('Pria'),
          value: JenisKelamin.pria,
          groupValue: _jenisKelaminSaatIni,
          onChanged: (JenisKelamin? value) {
            setState(() {
              _jenisKelaminSaatIni = value;
            });
          },
          dense: true,
          activeColor: Theme.of(context).primaryColor,
        ),
        RadioListTile<JenisKelamin>(
          title: const Text('Wanita'),
          value: JenisKelamin.wanita,
          groupValue: _jenisKelaminSaatIni,
          onChanged: (JenisKelamin? value) {
            setState(() {
              _jenisKelaminSaatIni = value;
            });
          },
          dense: true,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  // Widget Pembantu: Daftar Checkbox
  List<Widget> _buildCheckboxList() {
    return _hobiStatus.keys.map((String key) {
      return CheckboxListTile(
        title: Text(key),
        value: _hobiStatus[key],
        onChanged: (bool? value) {
          setState(() {
            _hobiStatus[key] = value!;
          });
        },
        dense: true,
        activeColor: Theme.of(context).primaryColor,
        controlAffinity: ListTileControlAffinity.leading,
      );
    }).toList();
  }

  // Widget Pembantu: Card untuk Hasil (Tampilan yang Rapi)
  Widget _buildResultCard() {
    // Membangun Map data hasil langsung dari state
    final dataMap = {
      'Nama': _namaController.text.isEmpty ? "Tidak diisi" : _namaController.text,
      'Umur': _umurController.text.isEmpty ? "Tidak diisi" : "${_umurController.text} tahun",
      'Jenis Kelamin': _jenisKelaminSaatIni == JenisKelamin.pria
          ? "Pria"
          : _jenisKelaminSaatIni == JenisKelamin.wanita
          ? "Wanita"
          : "Belum dipilih",
      'Hobi': _hobiStatus.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .join(", "),
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hasil Input Tersimpan:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.indigo),
            ),
            const SizedBox(height: 15),

            if (_hasilInput == "Tekan 'Simpan' untuk melihat hasil input.")
              const Text(
                "Tekan 'Simpan' untuk melihat ringkasan biodata yang telah diisi.",
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              )
            else
            // Menampilkan daftar data yang terstruktur
              Column(
                children: dataMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label (Key)
                        SizedBox(
                          width: 120, // Lebar tetap agar sejajar
                          child: Text(
                            "${entry.key}:",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Nilai (Value)
                        Expanded(
                          child: Text(
                            entry.value.isEmpty ? "Tidak diisi" : entry.value,
                            style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}