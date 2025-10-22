// lib/about_page.dart
import 'package:flutter/material.dart';
import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Pastikan 'assets/logo_uin.png' tersedia di folder assets
              Image.asset(
                'assets/logo_uin.png',
                height: 120,
              ),
              const SizedBox(height: 24),
              Text(
                'Aplikasi Kuesioner Kepuasan Kampus',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                Icons.book_online,
                'Mata Kuliah & Dosen Pengampu',
                'Pemrograman Perangkat Mobile\nAhmad Nasukha, S.Hum., M.S.I.',
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                Icons.code,
                'Pengembang Aplikasi',
                'Neni Andriana 701230007\nProgram Studi Sistem Informasi',
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                Icons.calendar_today,
                'Tahun Akademik',
                'Ganjil 2024/2025',
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  // Asumsikan createRoute ada di home_page.dart
                  // Anda harus memastikan file home_page.dart juga diimpor di about_page.dart
                  Navigator.pushAndRemoveUntil(
                    context,
                    createRoute(const HomePage()),
                        (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Beranda'),
                style: FilledButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, IconData icon, String title, String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    // 🚨 PERBAIKAN KRITIS: Tambahkan maxLines: 2 untuk judul yang panjang
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(content,
                    style: Theme.of(context).textTheme.bodyLarge,
                    // Tetap mempertahankan maxLines 5 untuk konten
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}