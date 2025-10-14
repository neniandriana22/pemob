// File: lib/ui/mahasiswa_item.dart
import 'package:flutter/material.dart';
import '../model/mahasiswa.dart';

class MahasiswaItem extends StatelessWidget {
  final Mahasiswa? mahasiswa;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MahasiswaItem({
    Key? key,
    required this.mahasiswa,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          mahasiswa!.nama.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            mahasiswa!.nim.toString(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}