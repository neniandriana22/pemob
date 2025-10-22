// lib/pages/dosen_detail_page.dart (KODE FINAL ANTI-OVERFLOW)

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/dosen.dart';
import 'dosen_create_page.dart';

class DosenDetailPage extends StatelessWidget {
  final Dosen dosen;
  final Function(Dosen updatedDosen)? onUpdate;

  const DosenDetailPage({super.key, required this.dosen, this.onUpdate});

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Tidak dapat memanggil $phoneNumber');
    }
  }

  Future<void> _launchEmail(String emailAddress) async {
    final Uri url = Uri(scheme: 'mailto', path: emailAddress);
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Tidak dapat mengirim email ke $emailAddress');
    }
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey, size: 24),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildQuickActionButton(
      {required IconData icon, required String label, required VoidCallback onTap, required Color color}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(10), // Mengurangi padding kontainer ikon
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
            child: Icon(icon, color: color, size: 26), // Mengurangi ukuran ikon
          ),
        ),
        const SizedBox(height: 5), // Mengurangi jarak di bawah ikon
        Text(
          label,
          style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Detail Dosen'),
        backgroundColor: Colors.blueGrey.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        // Menambahkan padding bawah yang lebih besar untuk mencegah luapan di perangkat kecil
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            // HEADER PROFIL
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  // Menggunakan padding atas standar
                  padding: EdgeInsets.only(top: 10.0 + statusBarHeight, bottom: 10.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40, // PERBAIKAN: Mengurangi radius (menghemat 20px vertikal)
                        backgroundImage: AssetImage(dosen.fotoUrl),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 8), // PERBAIKAN: Mengurangi jarak
                      Text(
                        dosen.nama,
                        style: const TextStyle(
                          fontSize: 20, // Mengurangi font
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        dosen.bidangKeahlian,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Aksi Cepat (Telepon & Email)
            Padding(
              // PERBAIKAN: Mengurangi padding vertikal di sini
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.phone,
                    label: "Telepon",
                    color: Colors.green.shade600,
                    onTap: () => _launchPhoneCall(dosen.telepon),
                  ),
                  _buildQuickActionButton(
                    icon: Icons.email,
                    label: "Email",
                    color: Colors.red.shade600,
                    onTap: () => _launchEmail(dosen.email),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),

            // Detail Informasi (NIDN, Telepon, Email)
            Card(
              // PERBAIKAN: Mengurangi margin bawah
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  _buildDetailItem('NIDN', dosen.nidn, Icons.numbers),
                  _buildDetailItem('Telepon', dosen.telepon, Icons.phone_android),
                  _buildDetailItem('Email', dosen.email, Icons.alternate_email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}