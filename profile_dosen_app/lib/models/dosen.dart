class Dosen {
  final String nama;
  final String nidn; // Perbaiki: Gunakan nidn
  final String bidangKeahlian;
  final String email;
  final String fotoUrl; // Path untuk aset gambar (misal: 'assets/images/Neni.jpg')

  const Dosen({
    required this.nama,
    required this.nidn,
    required this.bidangKeahlian,
    required this.email,
    required this.fotoUrl,
  });
}

// Data Dummy untuk ditampilkan di ListView
const List<Dosen> daftarDosen = [
  Dosen(
    nama: 'Dr. Neni Andriana, S.Kom., M.T.',
    nidn: '0412038001',
    bidangKeahlian: 'Sistem Informasi dan Basis Data',
    email: 'neni.andriana@university.ac.id',
    // Ganti dengan path aset gambar yang valid, misalnya:
    // Jika Anda punya folder 'assets/images', maka path-nya 'assets/images/Neni.jpg'
    fotoUrl: 'assets/images/Neni.jpg', // ASUMSI: Anda akan membuat aset ini
  ),
  Dosen(
    nama: 'Prof. Putri Natalia, Ph.D.',
    nidn: '0420057502',
    bidangKeahlian: 'Jaringan Komputer dan Keamanan',
    email: 'putri.natalia@university.ac.id',
    fotoUrl: 'assets/images/Putri.jpg', // ASUMSI: Anda akan membuat aset ini
  ),
  Dosen(
    nama: 'Ir. Dean Novy, M.Kom.',
    nidn: '0410017803',
    bidangKeahlian: 'Rekayasa Perangkat Lunak',
    email: 'dean.novy@university.ac.id',
    fotoUrl: 'assets/images/Dean.jpg', // ASUMSI: Anda akan membuat aset ini
  ),
];