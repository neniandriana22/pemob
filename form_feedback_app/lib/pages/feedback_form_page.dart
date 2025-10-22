import 'package:flutter/material.dart';
import 'feedback_detail_page.dart'; // Import Halaman Detail untuk navigasi

// ============== BAGIAN 2: HALAMAN FORMULIR (StatefulWidget) ==============
class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

// State Class untuk mengelola data input
class _FeedbackFormPageState extends State<FeedbackFormPage> {
  // Menggunakan GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // State untuk Rating
  double _rating = 3.0; // Nilai awal rating 3

  @override
  void dispose() {
    // Penting: Membuang controller saat widget dihapus untuk mencegah kebocoran memori
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // Fungsi yang dipanggil saat tombol Bintang ditekan
  void _setRating(double newRating) {
    setState(() {
      _rating = newRating;
    });
  }

  // Fungsi untuk menangani penekanan tombol 'Kirim Feedback'
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String comment = _commentController.text.trim();
      final double rating = _rating;

      final feedbackData = {
        'name': name,
        'comment': comment,
        'rating': rating,
      };

      // Menggunakan Navigator untuk berpindah ke halaman detail (Halaman 2)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackDetailPage(data: feedbackData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Feedback Pelanggan"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Input Nama (TextField)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Anda',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Komentar (TextField)
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Komentar/Saran Anda',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.comment),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Komentar wajib diisi!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bagian Rating Bintang
              const Text(
                'Berikan Rating Anda (1-5):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starRating = index + 1;
                  return IconButton(
                    icon: Icon(
                      starRating <= _rating.round() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40.0,
                    ),
                    onPressed: () => _setRating(starRating.toDouble()),
                  );
                }),
              ),
              Text(
                'Rating Anda: ${_rating.toStringAsFixed(1)} Bintang',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 40),

              // Tombol Aksi
              ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Feedback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}