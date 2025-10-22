// lib/feedback_detail_page.dart

// ... (Kode Detail Page tetap sama dari perbaikan sebelumnya)
import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem feedback;

  const FeedbackDetailPage({super.key, required this.feedback});

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Feedback?'),
          content: Text(
              'Anda yakin ingin menghapus feedback dari ${feedback.namaMahasiswa}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('BATAL'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('HAPUS', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      Navigator.pop(context, 'delete');
    }
  }

  Widget _buildDetailTile(BuildContext context, IconData icon, String label,
      String value, {Color? color}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading:
        Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
        title: Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(value,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      ),
    );
  }

  Color _getFeedbackColor(JenisFeedback jenis) {
    switch (jenis) {
      case JenisFeedback.saran:
        return Colors.blue.shade600;
      case JenisFeedback.keluhan:
        return Colors.red.shade600;
      case JenisFeedback.apresiasi:
        return Colors.green.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Judul Utama dengan Ikon
              Card(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(feedback.iconData,
                          size: 40,
                          color: _getFeedbackColor(feedback.jenisFeedback)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(feedback.jenisFeedbackString,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                  color: _getFeedbackColor(
                                      feedback.jenisFeedback),
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('Feedback dari:',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Data Mahasiswa (Dipanggil dengan benar)
              _buildDetailTile(context, Icons.person, 'Nama Mahasiswa',
                  feedback.namaMahasiswa),
              _buildDetailTile(context, Icons.credit_card, 'NIM', feedback.nim),

              // Data lainnya
              _buildDetailTile(
                  context, Icons.school, 'Fakultas', feedback.fakultas),
              _buildDetailTile(context, Icons.list_alt,
                  'Fasilitas yang Dipilih', feedback.fasilitasDinilai.join(', ')),
              _buildDetailTile(context, Icons.star, 'Nilai Kepuasan',
                  '${feedback.nilaiKepuasan.round()} dari 5',
                  color: Colors.amber),
              _buildDetailTile(
                  context,
                  Icons.gavel,
                  'Status Setuju S&K',
                  feedback.setujuSyaratKetentuan ? 'Disetujui' : 'Tidak Disetujui',
                  color: feedback.setujuSyaratKetentuan ? Colors.green : Colors.red),

              // Pesan Tambahan (jika ada)
              if (feedback.pesanTambahan != null &&
                  feedback.pesanTambahan!.isNotEmpty)
                Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes,
                                color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('Pesan Tambahan',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(feedback.pesanTambahan!,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.justify),
                      ],
                    ),
                  ),
                ),

              // Tombol Aksi
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali'),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showDeleteConfirmation(context),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}