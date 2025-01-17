import './shares_page_controller.dart';
import 'package:flutter/material.dart';
import '../share_model.dart';
import '../share_view.dart';

class SharesPage extends StatefulWidget {
  const SharesPage({super.key});

  @override
  _SharesPageState createState() => _SharesPageState();
}

class _SharesPageState extends State<SharesPage> {
  late Future<List<ShareModel>> _sharesFuture;
  late List<ShareModel> _allShares;
  late List<ShareModel> _filteredShares;

  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShares();
  }

  Future<void> _loadShares() async {
    _sharesFuture = SharePageController().getShares();
    List<ShareModel> shares = await _sharesFuture;
    setState(() {
      _allShares = shares;
      _filteredShares = shares;
    });
  }

  void onChanged(String query) {
    setState(() {
      _filteredShares = SharePageController().fuzzySearch(_allShares, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: textController,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              prefixIcon: Icon(Icons.search, color: Colors.blue),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ShareModel>>(
        future: _sharesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (_filteredShares.isEmpty) {
            return const Center(child: Text('No shares available.'));
          } else {
            return ListView.builder(
              itemCount: _filteredShares.length,
              itemBuilder: (context, index) {
                return ShareView(share: _filteredShares[index]);
              },
            );
          }
        },
      ),
    );
  }
}
