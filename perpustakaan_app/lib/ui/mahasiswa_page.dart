// File: lib/ui/mahasiswa_page.dart

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'mahasiswa_form.dart';
import 'mahasiswa_item.dart';
import '../model/mahasiswa.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({Key? key}) : super(key: key);

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  // Data dummy mahasiswa
  List<Mahasiswa> _mahasiswaList = [
    Mahasiswa(
      nim: "701230007",
      nama: "Neni Andriana",
      alamat: "Sembubuk",
    ),
    Mahasiswa(
      nim: "12345678",
      nama: "Deand Novy Turnip",
      alamat: "Simpang Lima",
    ),
    Mahasiswa(
      nim: "12345678",
      nama: "Putri Natalia Br Tambunan",
      alamat: "Bukit Baling",
    ),
  ];

  void _addMahasiswa(Mahasiswa newMhs) {
    setState(() {
      _mahasiswaList.add(newMhs);
    });
  }

  void _editMahasiswa(Mahasiswa editedMhs, String oldNim) {
    setState(() {
      int index = _mahasiswaList.indexWhere((mhs) => mhs.nim == oldNim);
      if (index != -1) {
        _mahasiswaList[index] = editedMhs;
      }
    });
  }

  void _deleteMahasiswa(String nim) {
    setState(() {
      _mahasiswaList.removeWhere((mhs) => mhs.nim == nim);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mahasiswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newMhs = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MahasiswaForm()),
              );
              if (newMhs != null) {
                // Saat menambah, newMhs langsung objek Mahasiswa
                _addMahasiswa(newMhs);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _mahasiswaList.length,
        itemBuilder: (context, index) {
          final mhs = _mahasiswaList[index];
          return MahasiswaItem(
            mahasiswa: mhs,
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MahasiswaForm(mahasiswaToEdit: mhs),
                ),
              );

              if (result != null) {
                // Periksa apakah hasil adalah Map (dari mode edit) atau Mahasiswa (dari mode tambah)
                if (result is Map) {
                  final editedMhs = result['mahasiswa'] as Mahasiswa;
                  final oldNim = result['oldNim'] as String;
                  _editMahasiswa(editedMhs, oldNim);
                }
              }
            },
            onDelete: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                title: 'Konfirmasi Hapus',
                desc: 'Apakah Anda yakin ingin menghapus data ini?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  _deleteMahasiswa(mhs.nim!);
                },
              ).show();
            },
          );
        },
      ),
    );
  }
}