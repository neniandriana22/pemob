// lib/home_page.dart
import 'package:flutter/material.dart';
import 'main.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';

// Route kustom untuk transisi animasi (Bonus)
Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(Tween(begin: 0.5, end: 1.0)),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildHomeButton(BuildContext context,
      {required IconData icon,
        required String label,
        required Widget page,
        bool isPrimary = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: isPrimary
          ? ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(createRoute(page));
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
      )
          : OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(createRoute(page));
        },
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // Judul AppBar terlihat jelas
        title: const Text('Campus Feedback System'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Tombol Toggle Dark Mode
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.mode_night),
            onPressed: () {
              MyApp.of(context).toggleTheme();
            },
            tooltip: 'Toggle Dark/Light Mode',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Logo UIN STS Jambi
              Image.asset(
                'assets/logo_flutter.png',
                height: 100,
              ),
              const SizedBox(height: 16),
              Text('Flutter Campus Feedback',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Kuesioner Kepuasan Mahasiswa',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 48),
              _buildHomeButton(context,
                  icon: Icons.rate_review,
                  label: 'Isi Formulir Feedback Mahasiswa',
                  page: const FeedbackFormPage()),
              _buildHomeButton(context,
                  icon: Icons.list_alt,
                  label: 'Lihat Daftar Feedback',
                  page: const FeedbackListPage()),
              _buildHomeButton(context,
                  icon: Icons.info_outline,
                  label: 'Tentang Aplikasi / Profil',
                  page: const AboutPage(),
                  isPrimary: false),
              const Spacer(),
              Card(
                elevation: 0,
                color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "\"Coding adalah seni memecahkan masalah dengan logika dan kreativitas.\"",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
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