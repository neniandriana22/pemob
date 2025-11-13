// File: lib/shopping_list_screen.dart (Kode penuh yang sudah diperbaiki)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'shopping_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _shoppingList = [];
  bool _isLoading = true;
  final String _storageKey = 'shopping_list';

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  // --- Persistent Storage (SharedPreferences) ---

  Future<void> _loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    String? listString = prefs.getString(_storageKey);

    if (listString != null) {
      List<dynamic> listJson = jsonDecode(listString);
      setState(() {
        _shoppingList = listJson
            .map((json) => ShoppingItem.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> listJson =
    _shoppingList.map((item) => item.toJson()).toList();
    String listString = jsonEncode(listJson);
    await prefs.setString(_storageKey, listString);
  }

  // --- Fungsi CRUD ---

  void _addItem(String name, int quantity, String category) {
    setState(() {
      _shoppingList.add(ShoppingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        quantity: quantity,
        category: category,
      ));
    });
    _saveShoppingList();
  }

  void _toggleItemStatus(int index) {
    setState(() {
      _shoppingList[index].isBought = !_shoppingList[index].isBought;
    });
    _saveShoppingList();
  }

  void _updateItem(int index, String newName, int newQuantity, String newCategory) {
    setState(() {
      _shoppingList[index].name = newName;
      _shoppingList[index].quantity = newQuantity;
      _shoppingList[index].category = newCategory;
    });
    _saveShoppingList();
  }

  void _deleteItem(int index) {
    setState(() {
      _shoppingList.removeAt(index);
    });
    _saveShoppingList();
  }

  // --- Helper untuk Total Item ---
  String _getTotalStatus() {
    int total = _shoppingList.length;
    int bought = _shoppingList.where((item) => item.isBought).length;
    int remaining = total - bought;
    return 'Total: $total | Dibeli: $bought | Belum Dibeli: $remaining';
  }

  // --- UI Utama ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Shopping List App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_getTotalStatus())),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _shoppingList.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Daftar Belanja Kosong', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _shoppingList.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final item = _shoppingList[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Checkbox(
                value: item.isBought,
                onChanged: (val) => _toggleItemStatus(index),
                activeColor: Colors.green,
              ),
              title: Text(
                item.name,
                // Perbaikan: Hapus 'decoration: TextDecoration.lineThrough'
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('${item.quantity}x | Kategori: ${item.category}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showItemDialog(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(index),
                  ),
                ],
              ),
              onTap: () => _toggleItemStatus(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Tambah Item',
      ),
    );
  }

  // --- Dialog untuk Tambah/Edit Item ---
  // (Fungsi ini tidak diubah)
  void _showItemDialog({int? index}) {
    final isEdit = index != null;
    final item = isEdit ? _shoppingList[index!] : null;

    final nameController = TextEditingController(text: item?.name ?? '');
    final quantityController = TextEditingController(text: item?.quantity.toString() ?? '1');
    final categoryController = TextEditingController(text: item?.category ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? '✏️ Edit Item Belanja' : '➕ Tambah Item Belanja'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Item', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
              final category = categoryController.text.trim();

              if (name.isNotEmpty && category.isNotEmpty && quantity > 0) {
                if (isEdit) {
                  _updateItem(index!, name, quantity, category);
                  _showSnackbar('Item diperbarui');
                } else {
                  _addItem(name, quantity, category);
                  _showSnackbar('Item ditambahkan');
                }
                Navigator.pop(context);
              } else {
                _showSnackbar('Nama Item, Jumlah, dan Kategori harus diisi!', isError: true);
              }
            },
            child: Text(isEdit ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  // --- Dialog untuk Konfirmasi Hapus ---
  // (Fungsi ini tidak diubah)
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Yakin ingin menghapus item "${_shoppingList[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteItem(index);
              Navigator.pop(context);
              _showSnackbar('Item dihapus');
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- Helper untuk Snackbar ---
  // (Fungsi ini tidak diubah)
  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}