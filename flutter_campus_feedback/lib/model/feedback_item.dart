// lib/model/feedback_item.dart
import 'package:flutter/material.dart';

// Definisikan tipe enum untuk Jenis Feedback
enum JenisFeedback { saran, keluhan, apresiasi }

// Kelas (Model) untuk menampung data Feedback Mahasiswa
class FeedbackItem {
  final String namaMahasiswa;
  final String nim;
  final String fakultas;
  final List<String> fasilitasDinilai;
  final double nilaiKepuasan;
  final JenisFeedback jenisFeedback;
  final bool setujuSyaratKetentuan;
  final String? pesanTambahan; // Field opsional untuk pesan

  // Konstruktor
  FeedbackItem({
    required this.namaMahasiswa,
    required this.nim,
    required this.fakultas,
    required this.fasilitasDinilai,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    required this.setujuSyaratKetentuan,
    this.pesanTambahan, // Masukkan ke konstruktor
  });

  // Helper untuk mengubah enum menjadi String yang rapi
  String get jenisFeedbackString {
    switch (jenisFeedback) {
      case JenisFeedback.saran:
        return 'Saran';
      case JenisFeedback.keluhan:
        return 'Keluhan';
      case JenisFeedback.apresiasi:
        return 'Apresiasi';
    }
  }

  // Helper untuk mendapatkan ikon berdasarkan jenis feedback
  IconData get iconData {
    switch (jenisFeedback) {
      case JenisFeedback.saran:
        return Icons.lightbulb_outline;
      case JenisFeedback.keluhan:
        return Icons.report_problem_outlined;
      case JenisFeedback.apresiasi:
        return Icons.thumb_up_alt_outlined;
    }
  }

  // FUNGSI JSON: Konversi objek menjadi Map untuk SharedPreferences
  Map<String, dynamic> toJson() => {
    'namaMahasiswa': namaMahasiswa,
    'nim': nim,
    'fakultas': fakultas,
    'fasilitasDinilai': fasilitasDinilai,
    'nilaiKepuasan': nilaiKepuasan,
    'jenisFeedback': jenisFeedback.index,
    'setujuSyaratKetentuan': setujuSyaratKetentuan,
    'pesanTambahan': pesanTambahan, // TAMBAHAN
  };

  // FUNGSI JSON: Factory Constructor untuk membuat objek dari Map
  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      namaMahasiswa: json['namaMahasiswa'] as String,
      nim: json['nim'] as String,
      fakultas: json['fakultas'] as String,
      fasilitasDinilai: List<String>.from(json['fasilitasDinilai'] as List),
      nilaiKepuasan: json['nilaiKepuasan'] as double,
      jenisFeedback: JenisFeedback.values[json['jenisFeedback'] as int],
      setujuSyaratKetentuan: json['setujuSyaratKetentuan'] as bool,
      pesanTambahan: json['pesanTambahan'] as String?, // TAMBAHAN
    );
  }
}