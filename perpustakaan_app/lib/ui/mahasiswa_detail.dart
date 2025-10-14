// File: lib/ui/mahasiswa_detail.dart
import 'package:flutter/material.dart';
import '../model/mahasiswa.dart';

class MahasiswaDetail extends StatelessWidget {
  final Mahasiswa? mahasiswa;
  const MahasiswaDetail({Key? key, this.mahasiswa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Mahasiswa"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("NIM: ${mahasiswa!.nim}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 8.0),
            Text("Nama: ${mahasiswa!.nama}", style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 8.0),
            Text("Alamat: ${mahasiswa!.alamat}", style: const TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}