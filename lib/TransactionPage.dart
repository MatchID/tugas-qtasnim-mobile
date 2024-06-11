import 'package:flutter/material.dart';
import 'package:test_qtasnim/Comparation.dart';
import 'package:test_qtasnim/models/transaksi.dart';
import 'package:test_qtasnim/utility/api_provider.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Transaksi> _transactions = [];
  List<Transaksi> _filteredTransactions = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String _sortBy = 'namaBarang';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _searchController.addListener(_filterTransactions);
  }

  Future<void> _fetchTransactions() async {
    try {
      final apiProvider = ApiProvider();
      final response = await apiProvider.get(url: '/api/transaksi');
      final List<Transaksi> transactions = transaksiFromJson(response);
      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching transactions: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data. Please try again later.'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterTransactions() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _transactions.where((transaksi) {
        return transaksi.namaBarang.toLowerCase().contains(query);
      }).toList();
      _sortTransactions();
    });
  }

  void _sortTransactions() {
    setState(() {
      _filteredTransactions.sort((a, b) {
        int compare;
        if (_sortBy == 'namaBarang') {
          compare = a.namaBarang.compareTo(b.namaBarang);
        } else {
          compare = a.tanggalTransaksi.compareTo(b.tanggalTransaksi);
        }
        return _isAscending ? compare : -compare;
      });
    });
  }

  void _onSortByChanged(String value) {
    if (value == "comparation") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ComparationPage()),
      );
    } else {
      setState(() {
        _sortBy = value;
        _sortTransactions();
      });
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Transaksi'),
        actions: [
          IconButton(
            icon:
                Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: _toggleSortOrder,
          ),
          PopupMenuButton<String>(
            onSelected: _onSortByChanged,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'namaBarang',
                  child: Text('Sort by Name'),
                ),
                PopupMenuItem<String>(
                  value: 'tanggalTransaksi',
                  child: Text('Sort by Date'),
                ),
                PopupMenuItem<String>(
                  value: 'comparation',
                  child: Text('Comparation'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredTransactions.isEmpty
                    ? Center(child: Text('Data Kosong'))
                    : ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaksi = _filteredTransactions[index];
                          return TransactionItem(
                            transaksi: transaksi,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class TransactionItem extends StatelessWidget {
  final Transaksi transaksi;

  const TransactionItem({
    required this.transaksi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(transaksi.namaBarang),
        subtitle: Text(
            'Jenis: ${transaksi.jenisBarang}\nStok: ${transaksi.stok}\nTerjual: ${transaksi.jumlahTerjual}\nDate: ${transaksi.tanggalTransaksi}'),
      ),
    );
  }
}
