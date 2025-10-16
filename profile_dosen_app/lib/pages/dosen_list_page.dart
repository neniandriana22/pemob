import 'package:flutter/material.dart';
import '../models/dosen.dart'; // Path import yang benar
import 'dosen_detail_page.dart';

class DosenListPage extends StatelessWidget {
  const DosenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Profil Dosen"),
        backgroundColor: Colors.teal,
        elevation: 0, // Desain lebih modern
      ),
      // Menggunakan ListView.builder untuk menampilkan daftar
      body: ListView.builder(
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];

          // Setiap item dalam daftar dibungkus dalam Card dengan desain menarik
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(dosen.fotoUrl),
                  backgroundColor: Colors.teal.shade100,
                ),
                title: Text(
                  dosen.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  dosen.bidangKeahlian,
                  style: TextStyle(color: Colors.grey[600]),
                ),

                trailing: const Icon(Icons.chevron_right, color: Colors.teal, size: 28),

                // Aksi navigasi (Navigator) saat ListTile diklik
                onTap: () {
                  // Berpindah ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DosenDetailPage(dosen: dosen),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}