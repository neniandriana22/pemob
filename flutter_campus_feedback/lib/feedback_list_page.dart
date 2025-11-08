// lib/feedback_list_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

const String _kFeedbackListKey = 'feedbackList';

List<FeedbackItem> _feedbackList = [];

class FeedbackListPage extends StatefulWidget {
  final FeedbackItem? newFeedback;

  const FeedbackListPage({super.key, this.newFeedback});

  static List<FeedbackItem> getCurrentList() {
    return _feedbackList;
  }

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndCheckData();
  }

  Future<void> _loadAndCheckData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? feedbackString = prefs.getString(_kFeedbackListKey);

    if (feedbackString != null) {
      final List<dynamic> jsonList = jsonDecode(feedbackString);
      _feedbackList = jsonList
          .map((json) => FeedbackItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      _feedbackList = [];
    }

    if (widget.newFeedback != null) {
      _feedbackList.insert(0, widget.newFeedback!);
      await _saveData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _feedbackList.map((item) => item.toJson()).toList();
    final String feedbackString = jsonEncode(jsonList);
    await prefs.setString(_kFeedbackListKey, feedbackString);
  }

  void _deleteFeedback(FeedbackItem item) async {
    setState(() {
      _feedbackList.remove(item);
    });
    await _saveData();
  }

  void _navigateToDetail(BuildContext context, FeedbackItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackDetailPage(feedback: item),
      ),
    );

    if (result == 'delete') {
      _deleteFeedback(item);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback berhasil dihapus dari daftar.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildFeedbackTile(BuildContext context, FeedbackItem item) {
    Color iconColor = item.jenisFeedback == JenisFeedback.keluhan
        ? Colors.red.shade600 // Keluhan: Merah
        : item.jenisFeedback == JenisFeedback.apresiasi
            ? Colors.green.shade600 // Apresiasi: Hijau
            : Colors.yellow.shade700; // Saran: Kuning

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          item.iconData,
          color: iconColor,
          size: 32,
        ),
        title: Text(item.namaMahasiswa,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fakultas: ${item.fakultas}', overflow: TextOverflow.ellipsis),
            Text('Jenis: ${item.jenisFeedbackString}',
                overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4)),
          child: Text('${item.nilaiKepuasan.round()}/5',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        onTap: () => _navigateToDetail(context, item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Daftar Feedback Mahasiswa'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FeedbackSearchDelegate(
                    initialList: FeedbackListPage.getCurrentList()),
              );
            },
            tooltip: 'Cari Feedback',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feedbackList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('Belum ada feedback yang masuk.',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('Data disimpan secara lokal.',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _feedbackList.length,
                  itemBuilder: (context, index) {
                    final item = _feedbackList[index];
                    return _buildFeedbackTile(context, item);
                  },
                ),
    );
  }
}

class FeedbackSearchDelegate extends SearchDelegate<String> {
  final List<FeedbackItem> initialList;

  FeedbackSearchDelegate({required this.initialList});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = initialList
        .where((item) =>
            item.namaMahasiswa.toLowerCase().contains(query.toLowerCase()) ||
            item.fakultas.toLowerCase().contains(query.toLowerCase()) ||
            item.nim.contains(query))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return _buildSearchListTile(context, item);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = initialList
        .where((item) =>
            item.namaMahasiswa.toLowerCase().contains(query.toLowerCase()) ||
            item.fakultas.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final item = suggestionList[index];
        return ListTile(
          leading: Icon(item.iconData),
          title: Text(
            item.namaMahasiswa,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(item.fakultas, overflow: TextOverflow.ellipsis),
          onTap: () {
            query = item.namaMahasiswa;
            showResults(context);
          },
        );
      },
    );
  }

  Widget _buildSearchListTile(BuildContext context, FeedbackItem item) {
    // Konsistensi Warna Ikon di Hasil Pencarian
    Color iconColor = item.jenisFeedback == JenisFeedback.keluhan
        ? Colors.red.shade600
        : item.jenisFeedback == JenisFeedback.apresiasi
            ? Colors.green.shade600
            : Colors.yellow.shade700;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Icon(item.iconData, color: iconColor), // Menggunakan warna ikon yang konsisten
        title: Text(
          item.namaMahasiswa,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Fakultas: ${item.fakultas} | Kepuasan: ${item.nilaiKepuasan.round()}/5',
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FeedbackDetailPage(feedback: item)),
          );
        },
      ),
    );
  }
}