import 'package:flutter/material.dart';

// ============== BAGIAN 3: HALAMAN DETAIL (StatelessWidget) ==============
class FeedbackDetailPage extends StatelessWidget {
  // Menerima data yang dikirim dari Halaman 1
  final Map<String, dynamic> data;

  const FeedbackDetailPage({super.key, required this.data});

  // Fungsi helper untuk mendapatkan ikon rating
  IconData _getRatingIcon(double rating) {
    if (rating >= 4.0) return Icons.sentiment_very_satisfied;
    if (rating >= 3.0) return Icons.sentiment_satisfied;
    if (rating >= 2.0) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  @override
  Widget build(BuildContext context) {
    final double rating = data['rating'] ?? 0.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Hasil Feedback"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Ikon Ringkasan Rating
                  Icon(
                    _getRatingIcon(rating),
                    size: 80,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(height: 15),

                  // Tampilan Rating
                  Center(
                    child: Text(
                      'Rating: ${rating.toStringAsFixed(1)} / 5',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blue),
                    ),
                  ),
                  const Divider(height: 30),

                  // Tampilan Nama
                  _buildDetailRow(
                      context,
                      icon: Icons.person_outline,
                      label: 'Nama Pelanggan',
                      value: data['name'] ?? 'N/A'
                  ),
                  const SizedBox(height: 20),

                  // Tampilan Komentar
                  _buildDetailRow(
                      context,
                      icon: Icons.notes,
                      label: 'Komentar',
                      value: data['comment'] ?? 'N/A',
                      isComment: true
                  ),
                  const SizedBox(height: 30),

                  // Tombol untuk kembali (Navigator.pop)
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kirim Feedback Lain'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget kustom untuk baris detail
  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value, bool isComment = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
        const SizedBox(height: 5),
        isComment
            ? Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300)
          ),
          child: Text(value, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
        )
            : Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}