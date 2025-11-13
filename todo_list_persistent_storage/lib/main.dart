import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_model.dart'; // Import model Todo dari file terpisah

void main() {
  // Pastikan binding Flutter sudah diinisialisasi sebelum menggunakan SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Todo List',
      theme: ThemeData(
        // Menggunakan primary color yang seragam
        primaryColor: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blueGrey)
            .copyWith(secondary: Colors.teal),
        useMaterial3: false,
      ),
      home: const TodoListScreen(),
    );
  }
}

// Enum untuk Filter
enum TodoFilter { all, completed, incomplete }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // --- Logika SharedPreferences (Penyimpanan Lokal) ---

  Future<void> _loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? todosString = prefs.getString('todos');

      if (todosString != null) {
        // Decode JSON string ke List<dynamic>
        final List<dynamic> todosJson = jsonDecode(todosString) as List<dynamic>;

        setState(() {
          // Mapping List<dynamic> ke List<Todo>
          _todos = todosJson.map((json) => Todo.fromJson(json as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data Todo: $e')),
        );
      }
    } finally {
      // Pastikan loading indicator hilang
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi List<Todo> ke List<Map> menggunakan toJson()
    final List<Map<String, dynamic>> todosJson =
    _todos.map((todo) => todo.toJson()).toList();
    // Encode List<Map> ke JSON string
    final String todosString = jsonEncode(todosJson);
    await prefs.setString('todos', todosString); // Simpan
  }

  // --- Logika CRUD ---

  void _addTodo(String title) {
    if (title.isEmpty) return;
    setState(() {
      _todos.add(
        Todo(
          // Menggunakan timestamp sebagai id unik sederhana
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          createdAt: DateTime.now(),
        ),
      );
    });
    _saveTodos();
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodos();
  }

  void _updateTodo(int index, String newTitle) {
    if (newTitle.isEmpty) return;
    setState(() {
      _todos[index].title = newTitle;
    });
    _saveTodos();
  }

  // --- Logika Filter ---

  List<Todo> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.incomplete:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  // --- Dialog & UI ---

  void _showTodoDialog({Todo? todo, int? index}) {
    final isEdit = todo != null;
    final controller = TextEditingController(text: isEdit ? todo.title : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Todo' : 'Tambah Todo Baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Judul Todo'),
          onSubmitted: (value) {
            // Memungkinkan simpan saat menekan 'done' pada keyboard
            _handleDialogSave(isEdit, index, controller.text);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _handleDialogSave(isEdit, index, controller.text);
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  void _handleDialogSave(bool isEdit, int? index, String title) {
    if (title.isNotEmpty) {
      if (isEdit) {
        if (index != null) {
          _updateTodo(index, title);
        }
      } else {
        _addTodo(title);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Todo diperbarui' : 'Todo ditambahkan'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent Todo List'),
        actions: [
          // Dropdown untuk Filter
          PopupMenuButton<TodoFilter>(
            initialValue: _currentFilter,
            onSelected: (TodoFilter result) {
              setState(() {
                _currentFilter = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TodoFilter>>[
              const PopupMenuItem<TodoFilter>(
                value: TodoFilter.all,
                child: Text('Semua'),
              ),
              const PopupMenuItem<TodoFilter>(
                value: TodoFilter.incomplete,
                child: Text('Belum Selesai'),
              ),
              const PopupMenuItem<TodoFilter>(
                value: TodoFilter.completed,
                child: Text('Selesai'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredTodos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _currentFilter == TodoFilter.all
                  ? 'Belum ada Todo.'
                  : 'Tidak ada Todo di filter ini.',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _filteredTodos.length,
        itemBuilder: (context, filterIndex) {
          final todo = _filteredTodos[filterIndex];
          // Mencari index asli di _todos untuk update/delete yang benar
          final originalIndex = _todos.indexOf(todo);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 1,
            child: ListTile(
              leading: Checkbox(
                value: todo.isCompleted,
                activeColor: Colors.green, // Checkbox berwarna hijau
                onChanged: (bool? value) {
                  if (originalIndex != -1) {
                    _toggleTodoStatus(originalIndex);
                  }
                },
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  // Ubah warna menjadi hijau, tanpa garis coret
                  color: todo.isCompleted ? Colors.green.shade700 : Colors.black,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                  'Dibuat: ${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}'),
              // Menghapus onTap pada ListTile
              onTap: null,

              // Menggunakan Row untuk ikon Edit dan Hapus
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Agar Row tidak memakan ruang berlebihan
                children: [
                  // Ikon Edit
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                    tooltip: 'Edit Todo',
                    onPressed: () {
                      if (originalIndex != -1) {
                        _showTodoDialog(todo: todo, index: originalIndex);
                      }
                    },
                  ),
                  // Ikon Hapus
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus Todo',
                    onPressed: () {
                      if (originalIndex != -1) {
                        _deleteTodo(originalIndex);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Todo dihapus')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(),
        tooltip: 'Tambah Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}