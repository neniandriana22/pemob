// lib/models/dosen.dart

class Dosen {
  final String nama;
  final String nidn;
  final String bidangKeahlian;
  final String email;
  final String telepon;
  final String fotoUrl;

  const Dosen({
    required this.nama,
    required this.nidn,
    required this.bidangKeahlian,
    required this.email,
    required this.telepon,
    required this.fotoUrl,
  });
}