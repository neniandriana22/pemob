import 'package:flutter/material.dart';
import 'pages/feedback_form_page.dart'; // Import Halaman Formulir

void main() {
  runApp(const FeedbackApp());
}

// ============== BAGIAN 1: KERANGKA APLIKASI (StatelessWidget) ==============
class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
      // Halaman awal adalah formulir feedback (Halaman 1)
      home: const FeedbackFormPage(),
    );
  }
}