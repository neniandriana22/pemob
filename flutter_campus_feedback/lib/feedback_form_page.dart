// lib/feedback_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'feedback_list_page.dart';
import 'model/feedback_item.dart';
import 'home_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  // 🚨 PERBAIKAN: Hanya deklarasikan controller dan state yang dibutuhkan:
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();

  // Variabel State untuk Dropdown, Slider, Radio, Switch:
  String? _fakultas;
  List<String> _fasilitasDipilih = [];
  double _nilaiKepuasan = 3.0;
  JenisFeedback? _jenisFeedback = JenisFeedback.saran;
  bool _setujuSyaratKetentuan = false;

  final List<String> _listFakultas = [
    'Tarbiyah dan Keguruan',
    'Syariah',
    'Ushuluddin dan Studi Agama',
    'Ekonomi dan Bisnis Islam',
    'Dakwah',
    'Sains dan Teknologi'
  ];

  final Map<String, bool> _listFasilitas = {
    'Perpustakaan': false,
    'Koneksi Wi-Fi': false,
    'Kantin / Kafetaria': false,
    'Sarana Olahraga': false,
    'Toilet / Kamar Mandi': false,
  };

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _showAgreementDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: const Text(
              'Anda harus menyetujui Syarat & Ketentuan sebelum dapat menyimpan feedback.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OKE'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    // 🚨 HANYA PANGGIL save() JIKA ANDA MENGGUNAKAN onSaved DI FORM
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!_setujuSyaratKetentuan) {
        _showAgreementDialog();
        return;
      }

      if (_fasilitasDipilih.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal satu Fasilitas yang Dinilai!'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Ambil nilai Nama dan NIM langsung dari Controller (Metode Paling Aman)
      final String finalNama = _namaController.text;
      final String finalNim = _nimController.text;

      final feedbackItem = FeedbackItem(
        // Menggunakan nilai dari Controller
        namaMahasiswa: finalNama,
        nim: finalNim,

        // Menggunakan nilai dari onSaved/state
        fakultas: _fakultas!,
        fasilitasDinilai: _fasilitasDipilih,
        nilaiKepuasan: _nilaiKepuasan,
        jenisFeedback: _jenisFeedback!,
        setujuSyaratKetentuan: _setujuSyaratKetentuan,
        pesanTambahan:
        _pesanController.text.isNotEmpty ? _pesanController.text : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback berhasil disimpan!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        createRoute(FeedbackListPage(newFeedback: feedbackItem)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Formulir Feedback Mahasiswa'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // DATA DIRI
            _buildSectionCard(
              context,
              'Data Diri Mahasiswa',
              Icons.person_search,
              [
                // TextField Nama Mahasiswa
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                      labelText: 'Nama Mahasiswa',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder()),
                  validator: (value) =>
                  (value == null || value.isEmpty) ? 'Nama wajib diisi.' : null,
                  // onSaved: Tidak perlu karena menggunakan controller
                ),
                const SizedBox(height: 16),

                // TextField NIM
                TextFormField(
                  controller: _nimController,
                  decoration: const InputDecoration(
                      labelText: 'NIM',
                      prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'NIM wajib diisi.'
                      : (value.length < 5)
                      ? 'NIM minimal 5 digit.'
                      : null,
                  // onSaved: Tidak perlu karena menggunakan controller
                ),
                const SizedBox(height: 16),

                // Dropdown Fakultas (Masih menggunakan onSaved)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Fakultas',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder()),
                  value: _fakultas,
                  isExpanded: true,
                  items: _listFakultas
                      .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, overflow: TextOverflow.ellipsis,)))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _fakultas = newValue;
                    });
                  },
                  validator: (value) =>
                  (value == null || value.isEmpty) ? 'Fakultas wajib dipilih.' : null,
                  onSaved: (value) => _fakultas = value!,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // PENILAIAN FASILITAS
            _buildSectionCard(
              context,
              'Penilaian Fasilitas Kampus',
              Icons.location_city,
              [
                const Text('Fasilitas yang Dinilai (Bisa lebih dari satu):',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ..._listFasilitas.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _listFasilitas[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _listFasilitas[key] = value!;
                        _fasilitasDipilih = _listFasilitas.entries
                            .where((e) => e.value)
                            .map((e) => e.key)
                            .toList();
                      });
                    },
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Nilai Kepuasan Fasilitas (Skala 1-5):',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.sentiment_dissatisfied, color: Colors.red),
                    Expanded(
                        child: Slider(
                          value: _nilaiKepuasan,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: _nilaiKepuasan.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _nilaiKepuasan = value;
                            });
                          },
                        )),
                    const Icon(Icons.sentiment_satisfied, color: Colors.green),
                  ],
                ),
                Center(
                    child: Text('Kepuasan: ${_nilaiKepuasan.round()} dari 5',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 24),

            // JENIS FEEDBACK & KONFIRMASI
            _buildSectionCard(
              context,
              'Jenis Umpan Balik & Konfirmasi',
              Icons.message,
              [
                const Text('Jenis Feedback:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...JenisFeedback.values.map((JenisFeedback jenis) {
                  return RadioListTile<JenisFeedback>(
                    title: Text(
                      jenis.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    value: jenis,
                    groupValue: _jenisFeedback,
                    onChanged: (JenisFeedback? value) {
                      setState(() {
                        _jenisFeedback = value;
                      });
                    },
                    dense: true,
                  );
                }).toList(),
                const Divider(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pesanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Pesan Tambahan (Opsional)',
                    hintText:
                    'Tuliskan detail keluhan, saran, atau apresiasi Anda di sini...',
                    prefixIcon: Icon(Icons.edit_note),
                    border: OutlineInputBorder(),
                  ),
                ),
                const Divider(height: 32),
                SwitchListTile(
                  title: const Text('Saya Setuju dengan Syarat & Ketentuan'),
                  value: _setujuSyaratKetentuan,
                  onChanged: (bool value) {
                    setState(() {
                      _setujuSyaratKetentuan = value;
                    });
                  },
                  secondary: const Icon(Icons.gavel),
                ),
              ],
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Feedback',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionCard(
    BuildContext context, String title, IconData icon, List<Widget> children) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    ),
  );
}