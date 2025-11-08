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
    transitionDuration: const Duration(milliseconds: 400), // Transisi lebih cepat
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // RAPIH: Widget untuk tombol disempurnakan agar lebih konsisten dan dapat digunakan kembali
  Widget _buildHomeButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget page,
      bool isPrimary = true}) {
    // KONSISTEN: Style untuk tombol utama (ElevatedButton)
    final elevatedStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    );

    // KONSISTEN: Style untuk tombol sekunder (OutlinedButton)
    final outlinedStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary, // Border yang lebih jelas
        width: 1.5,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12.0), // Jarak antar tombol
      child: isPrimary
          ? ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(createRoute(page));
              },
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: elevatedStyle,
            )
          : OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(createRoute(page));
              },
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: outlinedStyle,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final bodyMinHeight = screenHeight - appBarHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feedback'), // Judul lebih singkat
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Tooltip(
            message: 'Ganti Mode Gelap/Terang',
            child: Switch(
              value: isDarkMode,
              onChanged: (value) {
                MyApp.of(context).toggleTheme();
              },
              thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) {
                return Icon(
                    states.contains(MaterialState.selected) ? Icons.dark_mode : Icons.light_mode);
              }),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // PROFESIONAL: Layout dibuat responsif dengan SingleChildScrollView
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: bodyMinHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Spacer(),
                  // CANTIK: Tampilan logo lebih modern dengan CircleAvatar
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logo_flutter.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Flutter Campus Feedback',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kuesioner Kepuasan Mahasiswa',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildHomeButton(
                    context,
                    icon: Icons.rate_review_outlined,
                    label: 'Isi Formulir Feedback',
                    page: const FeedbackFormPage(),
                  ),
                  _buildHomeButton(
                    context,
                    icon: Icons.list_alt_outlined,
                    label: 'Lihat Daftar Feedback',
                    page: const FeedbackListPage(),
                  ),
                  _buildHomeButton(
                    context,
                    icon: Icons.info_outline,
                    label: 'Tentang Aplikasi',
                    page: const AboutPage(),
                    isPrimary: false,
                  ),
                  const Spacer(),
                  const Spacer(), // Memberi lebih banyak ruang di tengah
                  // RAPIH: Card untuk kutipan dengan style yang lebih halus
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "\"Coding adalah seni memecahkan masalah dengan logika dan kreativitas.\"",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
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
}
