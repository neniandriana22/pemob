// lib/pages/dosen_list_page.dart (KODE FINAL YANG SUDAH DIPERBAIKI)

import 'package:flutter/material.dart';
import '../models/dosen.dart';
import 'dosen_detail_page.dart';
import 'dosen_create_page.dart';

class DosenListPage extends StatefulWidget {
  const DosenListPage({super.key});

  @override
  State<DosenListPage> createState() => _DosenListPageState();
}

class _DosenListPageState extends State<DosenListPage> {
  // Data Dosen (State)
  final List<Dosen> _daftarDosen = [
    const Dosen(
      nama: 'Dr. Neni Andriana, S.Kom., M.T.',
      nidn: '0412038001',
      bidangKeahlian: 'Sistem Informasi dan Basis Data',
      email: 'neni.andriana@university.ac.id',
      telepon: '+6281234567890',
      fotoUrl: 'assets/images/Neni.jpg',
    ),
    const Dosen(
      nama: 'Prof. Putri Natalia, Ph.D.',
      nidn: '0420057502',
      bidangKeahlian: 'Jaringan Komputer dan Keamanan',
      email: 'putri.natalia@university.ac.id',
      telepon: '+6281211122233',
      fotoUrl: 'assets/images/Putri.jpg',
    ),
    const Dosen(
      nama: 'Ir. Dean Novy, M.Kom.',
      nidn: '0410017803',
      bidangKeahlian: 'Rekayasa Perangkat Lunak',
      email: 'dean.novy@university.ac.id',
      telepon: '+6281244455566',
      fotoUrl: 'assets/images/Dean.jpg',
    ),
  ];

  // C: CREATE - Fungsi untuk menambahkan Dosen baru
  void _addDosen(Dosen newDosen) {
    setState(() {
      _daftarDosen.add(newDosen);
    });
  }

  // U: UPDATE - Fungsi untuk mengupdate Dosen
  void _updateDosen(int index, Dosen updatedDosen) {
    setState(() {
      _daftarDosen[index] = updatedDosen;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedDosen.nama} berhasil diupdate.'),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  // D: DELETE - Fungsi untuk menghapus Dosen
  void _deleteDosen(int index) {
    setState(() {
      final deletedDosenName = _daftarDosen[index].nama;
      _daftarDosen.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$deletedDosenName berhasil dihapus.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Profil Dosen",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          // Tombol Tambah Dosen Baru (CREATE)
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
            onPressed: () async {
              final newDosen = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DosenCreatePage(),
                ),
              );

              if (newDosen != null) {
                _addDosen(newDosen);
              }
            },
          ),
        ],
      ),
      // R: READ - Menampilkan Daftar dengan Dismissible (DELETE)
      body: _daftarDosen.isEmpty
          ? const Center(child: Text("Belum ada data dosen."))
          : ListView.builder(
        padding: const EdgeInsets.only(top: 10.0),
        itemCount: _daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = _daftarDosen[index];

          // MENGGUNAKAN DISMISSIBLE UNTUK SWIPE-TO-DELETE
          return Dismissible(
            key: ValueKey(dosen.nidn),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: Text('Yakin ingin menghapus ${dosen.nama}?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              _deleteDosen(index);
            },
            // _DosenCard dengan callback onUpdate
            child: _DosenCard(
              dosen: dosen,
              onUpdate: (updatedDosen) => _updateDosen(index, updatedDosen),
            ),
          );
        },
      ),
    );
  }
}

// Custom Widget Card Dosen
class _DosenCard extends StatelessWidget {
  final Dosen dosen;
  final Function(Dosen updatedDosen)? onUpdate; // Callback untuk update

  // PERBAIKAN: Hapus 'const' dari constructor dan inisialisasi field
  final Color _cardColor = Colors.teal.shade50;
  final Color _iconColor = Colors.teal.shade600;

  // PERBAIKAN: Hapus 'const' dari constructor
  _DosenCard({super.key, required this.dosen, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () async {
          // Navigasi ke halaman detail dengan membawa callback update
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DosenDetailPage(
                dosen: dosen,
                onUpdate: onUpdate,
              ),
            ),
          );
        },
        child: Card(
          color: _cardColor,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // PERBAIKAN: Tambahkan 'const' di sini karena tidak menggunakan field yang non-const
                    border: Border.all(color: _iconColor, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(dosen.fotoUrl.isNotEmpty ? dosen.fotoUrl : 'assets/images/placeholder.jpg'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dosen.nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dosen.bidangKeahlian,
                        style: TextStyle(color: Colors.teal.shade700, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: _iconColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}