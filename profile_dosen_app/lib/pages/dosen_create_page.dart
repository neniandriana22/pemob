// lib/pages/dosen_create_page.dart

import 'package:flutter/material.dart';
import '../models/dosen.dart';

class DosenCreatePage extends StatefulWidget {
  // Data opsional: Jika diisi, ini adalah mode EDIT
  final Dosen? dosenToEdit;

  const DosenCreatePage({super.key, this.dosenToEdit});

  @override
  State<DosenCreatePage> createState() => _DosenCreatePageState();
}

class _DosenCreatePageState extends State<DosenCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nidnController = TextEditingController();
  final _bidangKeahlianController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _fotoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data dosen yang akan diedit (mode EDIT)
    if (widget.dosenToEdit != null) {
      _namaController.text = widget.dosenToEdit!.nama;
      _nidnController.text = widget.dosenToEdit!.nidn;
      _bidangKeahlianController.text = widget.dosenToEdit!.bidangKeahlian;
      _emailController.text = widget.dosenToEdit!.email;
      _teleponController.text = widget.dosenToEdit!.telepon;
      _fotoUrlController.text = widget.dosenToEdit!.fotoUrl;
    } else {
      // Set nilai default untuk mode CREATE
      _fotoUrlController.text = 'assets/images/placeholder.jpg';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final resultDosen = Dosen(
        nama: _namaController.text,
        nidn: _nidnController.text,
        bidangKeahlian: _bidangKeahlianController.text,
        email: _emailController.text,
        telepon: _teleponController.text,
        fotoUrl: _fotoUrlController.text.isNotEmpty ? _fotoUrlController.text : 'assets/images/placeholder.jpg',
      );

      // Mengirim kembali objek Dosen ke halaman sebelumnya (ListPage/DetailPage)
      Navigator.pop(context, resultDosen);
    }
  }

  // Widget pembantu untuk input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nidnController.dispose();
    _bidangKeahlianController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _fotoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.dosenToEdit != null;
    final String pageTitle = isEditing ? "Edit Profil Dosen" : "Tambah Profil Dosen Baru";
    final String buttonText = isEditing ? "Simpan Perubahan" : "Simpan Dosen Baru";

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Input Nama
              _buildInputField(
                controller: _namaController,
                label: 'Nama Lengkap dan Gelar',
                icon: Icons.person_outline,
                hint: 'Contoh: Dr. Budi Santoso, M.Kom.',
                validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),

              // Input NIDN
              _buildInputField(
                controller: _nidnController,
                label: 'NIDN',
                icon: Icons.badge_outlined,
                hint: 'Contoh: 0412345678',
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'NIDN tidak boleh kosong' : null,
              ),

              // Input Bidang Keahlian
              _buildInputField(
                controller: _bidangKeahlianController,
                label: 'Bidang Keahlian',
                icon: Icons.school_outlined,
                hint: 'Contoh: Data Science dan AI',
                validator: (value) => (value == null || value.isEmpty) ? 'Bidang Keahlian tidak boleh kosong' : null,
              ),

              // Input Email
              _buildInputField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                hint: 'Contoh: dosen@universitas.ac.id',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || value.isEmpty) ? 'Email tidak boleh kosong' : null,
              ),

              // Input Telepon
              _buildInputField(
                controller: _teleponController,
                label: 'Nomor Telepon',
                icon: Icons.phone_outlined,
                hint: 'Contoh: +62812xxxxxx',
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty) ? 'Nomor Telepon tidak boleh kosong' : null,
              ),

              // Input Foto URL
              _buildInputField(
                controller: _fotoUrlController,
                label: 'URL Foto Aset (Opsional)',
                icon: Icons.image_outlined,
                hint: 'Contoh: assets/images/dosen_baru.jpg',
                validator: (value) => null,
              ),

              const SizedBox(height: 30),

              // Tombol Simpan/Update
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(isEditing ? Icons.update : Icons.save, color: Colors.white),
                label: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}