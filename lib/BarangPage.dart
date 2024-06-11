import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/models/jenis_barang.dart';
import 'package:test_qtasnim/utility/api_provider.dart';

class BarangPage extends StatefulWidget {
  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<JenisBarang> _jenisBarang = [];
  List<Barang> _barangs = [];
  bool _isLoading = true;

  int _selectedJenisBarangId = 1;

  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final apiProvider = ApiProvider();
      final responseJenisBarang =
          await apiProvider.get(url: '/api/jenis-barang');
      final List<JenisBarang> jenisBarang =
          jenisBarangFromJson(responseJenisBarang);

      setState(() {
        _jenisBarang = jenisBarang;
      });
    } catch (error) {
      print('Error fetching jenis barang: $error');
    }

    _fetchBarangs();
  }

  Future<void> _fetchBarangs() async {
    try {
      final apiProvider = ApiProvider();
      final responseBarang = await apiProvider.get(url: '/api/barang');
      final List<Barang> barangs = barangFromJson(responseBarang);

      setState(() {
        _barangs = barangs;
        _isLoading = false;
      });
    } catch (error) {
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

  void _submitForm() async {
    final String namaBarang = _namaBarangController.text;
    final int stok = int.tryParse(_stokController.text) ?? 0;

    if (namaBarang.isEmpty || stok <= 0 || _selectedJenisBarangId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields.'),
        ),
      );
      return;
    }

    final Map<String, dynamic> body = {
      'nama_barang': namaBarang,
      'stok': stok,
      'id_jenis': _selectedJenisBarangId,
    };

    try {
      final apiProvider = ApiProvider();
      await apiProvider.post(url: '/api/barang', body: jsonEncode(body));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Barang added successfully.'),
        ),
      );

      _fetchBarangs();
    } catch (error) {
      print('Error adding barang: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding barang. Please try again later.'),
        ),
      );
    }
  }

  void _confirmDeleteBarang(int id) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this barang?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (confirm != null && confirm) {
      _deleteBarang(id);
    }
  }

  void _deleteBarang(int id) async {
    try {
      final apiProvider = ApiProvider();
      await apiProvider.delete(url: '/api/barang/$id');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Barang deleted successfully.'),
        ),
      );

      _fetchBarangs();
    } catch (error) {
      print('Error deleting barang: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting barang. Please try again later.'),
        ),
      );
    }
  }

  void _editBarang(Barang barang) async {
    final String namaBarang = _namaBarangController.text;
    final int stok = int.tryParse(_stokController.text) ?? 0;

    if (namaBarang.isEmpty || stok <= 0 || _selectedJenisBarangId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields.'),
        ),
      );
      return;
    }

    final Map<String, dynamic> body = {
      'nama_barang': namaBarang,
      'stok': stok,
      'id_jenis': _selectedJenisBarangId,
    };

    try {
      final apiProvider = ApiProvider();
      await apiProvider.put(
          url: '/api/barang/${barang.idBarang}', body: jsonEncode(body));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Barang updated successfully.'),
        ),
      );

      _fetchBarangs();
    } catch (error) {
      print('Error updating barang: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating barang. Please try again later.'),
        ),
      );
    }
  }

  void _showEditDialog(Barang barang) {
    _namaBarangController.text = barang.namaBarang;
    _stokController.text = barang.stok.toString();
    _selectedJenisBarangId = barang.idJenis;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedJenisBarangId,
                items: _jenisBarang
                    .map((jenisBarang) => DropdownMenuItem<int>(
                          value: jenisBarang.idJenis,
                          child: Text(jenisBarang.jenisBarang),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJenisBarangId = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _namaBarangController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stok'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                _editBarang(barang);
                Navigator.of(context).pop();
              },
              child: Text('EDIT'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barang Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButtonFormField<int>(
                    value: _selectedJenisBarangId,
                    items: _jenisBarang
                        .map((jenisBarang) => DropdownMenuItem<int>(
                              value: jenisBarang.idJenis,
                              child: Text(jenisBarang.jenisBarang),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedJenisBarangId = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _namaBarangController,
                    decoration: InputDecoration(labelText: 'Nama Barang'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Stok'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Barang'),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _barangs.length,
                      itemBuilder: (context, index) {
                        final barang = _barangs[index];
                        return ListTile(
                          title: Text(barang.namaBarang),
                          subtitle: Text('Stok: ${barang.stok}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _showEditDialog(barang),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    _confirmDeleteBarang(barang.idBarang),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
