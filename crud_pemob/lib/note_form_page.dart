import 'package:flutter/material.dart';
import 'home_page.dart'; // <--- INI PERBAIKANNYA (Import home_page, bukan note_model)

class NoteFormPage extends StatefulWidget {
  final Note? existingNote;
  const NoteFormPage({super.key, this.existingNote});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  final List<String> _inputCategories = ['Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];
  bool get isEditMode => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    _selectedCategory = widget.existingNote?.category ?? 'Kuliah';
    _selectedDate = widget.existingNote?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Sekarang sistem mengenali 'Note' karena sudah diimport dari home_page.dart
    final newNote = Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: _selectedDate,
      category: _selectedCategory,
    );

    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Catatan' : 'Catatan Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                      items: _inputCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Tanggal', border: OutlineInputBorder()),
                        child: Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Isi Catatan', border: OutlineInputBorder()),
                maxLines: 8,
                validator: (val) => val == null || val.trim().isEmpty ? 'Isi wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: Text(isEditMode ? 'Simpan Perubahan' : 'Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}