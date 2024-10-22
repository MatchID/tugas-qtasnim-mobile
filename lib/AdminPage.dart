import 'package:flutter/material.dart';
import 'package:test_qtasnim/BarangPage.dart';
import 'package:test_qtasnim/JenisBarangPage.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Administrator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat datang, Admin!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JenisBarangPage()),
                );
              },
              child: Text('Jenis Barang'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarangPage()),
                );
              },
              child: Text('Barang'),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     //
            //   },
            //   child: Text('Tombol Aksi Admin'),
            // ),
          ],
        ),
      ),
    );
  }
}
