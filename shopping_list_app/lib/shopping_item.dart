// File: lib/shopping_item.dart

class ShoppingItem {
  String id;
  String name; // Nama item
  int quantity; // Jumlah item
  String category; // Kategori (misalnya: Makanan, Minuman)
  bool isBought; // Status (Sudah dibeli/Belum)

  // Constructor
  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1, // Default quantity 1
    required this.category,
    this.isBought = false, // Default status is false (Belum dibeli)
  });

  // Konversi dari Map ke Object (untuk membaca dari storage)
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      category: json['category'] as String,
      isBought: json['isBought'] as bool,
    );
  }

  // Konversi dari Object ke Map (untuk menyimpan ke storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isBought': isBought,
    };
  }
}