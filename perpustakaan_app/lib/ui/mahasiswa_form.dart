// File: lib/ui/mahasiswa_form.dart
import 'package:flutter/material.dart';
import '../model/mahasiswa.dart';

class MahasiswaForm extends StatefulWidget {
  final Mahasiswa? mahasiswaToEdit;
  const MahasiswaForm({Key? key, this.mahasiswaToEdit}) : super(key: key);

  @override
  State<MahasiswaForm> createState() => _MahasiswaFormState();
}

class _MahasiswaFormState extends State<MahasiswaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nimTxtCtrl = TextEditingController();
  final _namaTxtCtrl = TextEditingController();
  final _alamatTxtCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswaToEdit != null) {
      _nimTxtCtrl.text = widget.mahasiswaToEdit!.nim!;
      _namaTxtCtrl.text = widget.mahasiswaToEdit!.nama!;
      _alamatTxtCtrl.text = widget.mahasiswaToEdit!.alamat!;
    }
  }

  @override
  void dispose() {
    _nimTxtCtrl.dispose();
    _namaTxtCtrl.dispose();
    _alamatTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mahasiswaToEdit == null ? "Tambah Mahasiswa" : "Edit Mahasiswa"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _txtFieldNim(),
              const SizedBox(height: 16.0),
              _txtFieldNama(),
              const SizedBox(height: 16.0),
              _txtFieldAlamat(),
              const SizedBox(height: 24.0),
              _tombolSimpan()
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _txtFieldNim() {
    return TextFormField(
      controller: _nimTxtCtrl,
      decoration: InputDecoration(
        labelText: "NIM",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'NIM tidak boleh kosong';
        }
        return null;
      },
    );
  }

  TextFormField _txtFieldNama() {
    return TextFormField(
      controller: _namaTxtCtrl,
      decoration: InputDecoration(
        labelText: "Nama",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  TextFormField _txtFieldAlamat() {
    return TextFormField(
      controller: _alamatTxtCtrl,
      decoration: InputDecoration(
        labelText: "Alamat",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Alamat tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _tombolSimpan() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Mahasiswa result = Mahasiswa(
              nim: _nimTxtCtrl.text,
              nama: _namaTxtCtrl.text,
              alamat: _alamatTxtCtrl.text,
            );
            if (widget.mahasiswaToEdit != null) {
              Navigator.pop(context, {
                'mahasiswa': result,
                'oldNim': widget.mahasiswaToEdit!.nim!,
              });
            } else {
              Navigator.pop(context, result);
            }
          }
        },
        child: Text(
          widget.mahasiswaToEdit == null ? "Simpan" : "Ubah",
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white, // Menambahkan warna teks putih
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // Mengubah warna latar belakang menjadi ungu tua
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}