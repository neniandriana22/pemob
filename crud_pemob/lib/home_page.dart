import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_form_page.dart'; // Import halaman form

// ------------------------------------------------------------------
// 1. MODEL DATA (Disimpan di sini agar tidak perlu file ke-4)
// ------------------------------------------------------------------
class Note {
  String title;
  String content;
  DateTime date;
  String category;

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}

// Global Variabel Tema
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// ------------------------------------------------------------------
// 2. HALAMAN UTAMA
// ------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _allNotes = [];
  bool _isLoading = true;
  String _selectedFilter = 'Semua';
  final List<String> _categories = ['Semua', 'Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _loadNotesFromStorage();
  }

  Future<void> _saveNotesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_allNotes.map((n) => n.toMap()).toList());
    await prefs.setString('user_notes', encodedData);
  }

  Future<void> _loadNotesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('user_notes');
    if (notesString != null) {
      final List<dynamic> decodedData = jsonDecode(notesString);
      setState(() {
        _allNotes = decodedData.map((item) => Note.fromMap(item)).toList();
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkNow = themeNotifier.value == ThemeMode.dark;
    themeNotifier.value = isDarkNow ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool('isDarkMode', !isDarkNow);
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Kuliah': return const Icon(Icons.book, color: Colors.blue);
      case 'Organisasi': return const Icon(Icons.handshake, color: Colors.orange);
      case 'Pribadi': return const Icon(Icons.home, color: Colors.green);
      default: return const Icon(Icons.star, color: Colors.purple);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  List<Note> get _filteredNotes {
    if (_selectedFilter == 'Semua') return _allNotes;
    return _allNotes.where((note) => note.category == _selectedFilter).toList();
  }

  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => const NoteFormPage()),
    );
    if (result != null) {
      setState(() => _allNotes.add(result));
      _saveNotesToStorage();
    }
  }

  Future<void> _editNote(Note note) async {
    int index = _allNotes.indexOf(note);
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => NoteFormPage(existingNote: note)),
    );
    if (result != null) {
      setState(() => _allNotes[index] = result);
      _saveNotesToStorage();
    }
  }

  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus "${note.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              setState(() => _allNotes.remove(note));
              _saveNotesToStorage();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(themeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.filter_list),
              underline: Container(),
              items: _categories.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedFilter = val);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredNotes.isEmpty
          ? const Center(child: Text("Tidak ada catatan"))
          : ListView.builder(
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: _getCategoryIcon(note.category)),
              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${_formatDate(note.date)} • ${note.category}"),
              onTap: () => _editNote(note),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteNote(note)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}