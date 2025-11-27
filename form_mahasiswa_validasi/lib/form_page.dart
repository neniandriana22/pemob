import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Key untuk Form
  final _personalFormKey = GlobalKey<FormState>();
  final _academicFormKey = GlobalKey<FormState>();

  // Controller
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();

  // State
  int _currentStep = 0;
  String? _selectedJurusan;
  double _semester = 1.0;
  bool _agree = false;

  // Data Map untuk Hobi
  Map<String, bool> _hobbies = {
    'Membaca': false,
    'Olahraga': false,
    'Coding': false,
    'Musik': false,
  };

  final List<String> _jurusanList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Manajemen Informatika'
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    super.dispose();
  }

  // --- FUNGSI PENGENDALI TOMBOL ---
  void _handleContinue() {
    // STEP 1: DATA PRIBADI
    if (_currentStep == 0) {
      // Kita validasi form
      if (_personalFormKey.currentState!.validate()) {
        // Jika SUKSES
        setState(() {
          _currentStep += 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lanjut ke Step 2...'), backgroundColor: Colors.green),
        );
      } else {
        // Jika GAGAL (Input ada yang salah)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal! Cek Nama/Email/HP ada yang merah?'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    // STEP 2: AKADEMIK
    else if (_currentStep == 1) {
      bool isJurusanValid = _academicFormKey.currentState!.validate();
      bool isHobiValid = _hobbies.containsValue(true); // Cek minimal 1 hobi true

      if (isJurusanValid && isHobiValid) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        // Beri tahu user apa yang kurang
        String errorMsg = "";
        if (!isJurusanValid) errorMsg += "Jurusan belum dipilih. ";
        if (!isHobiValid) errorMsg += "Hobi belum dipilih.";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    }
    // STEP 3: KONFIRMASI
    else if (_currentStep == 2) {
      if (_agree) {
        _submitForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Centang persetujuan dulu!'),
              backgroundColor: Colors.red
          ),
        );
      }
    }
  }

  void _handleCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Data berhasil dikirim!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Form Stepper')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,

        // MENGHUBUNGKAN FUNGSI KITA KE STEPPER
        onStepContinue: _handleContinue,
        onStepCancel: _handleCancel,

        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _handleContinue, // Pastikan ini memanggil fungsi handle
                  child: Text(_currentStep == 2 ? 'Kirim Data' : 'Lanjut'),
                ),
                const SizedBox(width: 10),
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: _handleCancel,
                    child: const Text('Kembali'),
                  ),
              ],
            ),
          );
        },

        steps: [
          // STEP 1
          Step(
            title: const Text('Data Pribadi'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.editing,
            content: Form(
              key: _personalFormKey, // PENTING: Key ini harus ada
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    // Validasi sederhana: Tidak boleh kosong
                    validator: (val) => (val == null || val.isEmpty) ? 'Nama harus diisi' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (val) => (val == null || !val.contains('@')) ? 'Email harus pakai @' : null,
                  ),
                  TextFormField(
                    controller: _hpController,
                    decoration: const InputDecoration(labelText: 'HP'),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val == null || val.isEmpty) ? 'HP harus diisi' : null,
                  ),
                ],
              ),
            ),
          ),

          // STEP 2
          Step(
            title: const Text('Akademik'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.editing,
            content: Form(
              key: _academicFormKey, // PENTING: Key ini harus ada
              child: Column(
                children: [
                  DropdownButtonFormField(
                    value: _selectedJurusan,
                    items: _jurusanList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _selectedJurusan = v),
                    decoration: const InputDecoration(labelText: 'Jurusan'),
                    validator: (v) => v == null ? 'Pilih Jurusan' : null,
                  ),
                  const SizedBox(height: 10),
                  const Text('Hobi (Pilih minimal satu):'),
                  ..._hobbies.keys.map((key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: _hobbies[key],
                      onChanged: (val) => setState(() => _hobbies[key] = val!),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // STEP 3
          Step(
            title: const Text('Konfirmasi'),
            isActive: _currentStep >= 2,
            state: StepState.editing,
            content: SwitchListTile(
              title: const Text('Setuju syarat & ketentuan'),
              value: _agree,
              onChanged: (val) => setState(() => _agree = val),
            ),
          ),
        ],
      ),
    );
  }
}