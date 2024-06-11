import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_qtasnim/models/jenis_barang.dart';
import 'package:test_qtasnim/utility/api_provider.dart';

class JenisBarangPage extends StatefulWidget {
  @override
  _JenisBarangPageState createState() => _JenisBarangPageState();
}

class _JenisBarangPageState extends State<JenisBarangPage> {
  final TextEditingController _jenisBarangController = TextEditingController();
  List<JenisBarang> _jenisBarangList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJenisBarang();
  }

  Future<void> _fetchJenisBarang() async {
    try {
      final apiProvider = ApiProvider();
      final response = await apiProvider.get(url: '/api/jenis-barang');
      final List<JenisBarang> jenisBarangList = jenisBarangFromJson(response);
      setState(() {
        _jenisBarangList = jenisBarangList;
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

  Future<void> _addJenisBarang() async {
    final String jenisBarang = _jenisBarangController.text.trim();
    if (jenisBarang.isNotEmpty) {
      try {
        final apiProvider = ApiProvider();
        final Map<String, dynamic> body = {'jenis_barang': jenisBarang};
        final response = await apiProvider.post(
          url: '/api/jenis-barang',
          body: jsonEncode(body),
        );
        print(response);
        _jenisBarangController.clear();
        _fetchJenisBarang();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding jenis barang. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _editJenisBarang(int id, String newName) async {
    try {
      final apiProvider = ApiProvider();
      final Map<String, dynamic> body = {'jenis_barang': newName};
      final response = await apiProvider.put(
        url: '/api/jenis-barang/$id',
        body: jsonEncode(body),
      );
      _fetchJenisBarang();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error editing jenis barang. Please try again.'),
        ),
      );
    }
  }

  Future<void> _deleteJenisBarang(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus jenis barang ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                _deleteConfirmed(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteConfirmed(int id) async {
    try {
      final apiProvider = ApiProvider();
      final response = await apiProvider.delete(url: '/api/jenis-barang/$id');
      print(response);
      _fetchJenisBarang();
    } catch (error) {
      print('CEKDATA ->: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting jenis barang. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jenis Barang'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _jenisBarangList.length,
              itemBuilder: (context, index) {
                final jenisBarang = _jenisBarangList[index];
                return ListTile(
                  title: Text(jenisBarang.jenisBarang),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Edit Jenis Barang'),
                            content: TextField(
                              controller: TextEditingController()
                                ..text = jenisBarang.jenisBarang,
                              onChanged: (value) {
                                jenisBarang.jenisBarang = value;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Batal'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Simpan'),
                                onPressed: () {
                                  _editJenisBarang(jenisBarang.idJenis,
                                      jenisBarang.jenisBarang);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    _deleteJenisBarang(jenisBarang.idJenis);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Tambah Jenis Barang'),
                content: TextField(
                  controller: _jenisBarangController,
                  decoration: InputDecoration(
                    hintText: 'Nama Jenis Barang',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Simpan'),
                    onPressed: () {
                      _addJenisBarang();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
