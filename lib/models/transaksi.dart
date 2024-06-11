import 'dart:convert';

List<Transaksi> transaksiFromJson(String str) =>
    List<Transaksi>.from(json.decode(str).map((x) => Transaksi.fromJson(x)));

String transaksiToJson(List<Transaksi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaksi {
  int idTransaksi;
  int idBarang;
  int jumlahTerjual;
  DateTime tanggalTransaksi;
  String namaBarang;
  int stok;
  int idJenis;
  String jenisBarang;

  Transaksi({
    required this.idTransaksi,
    required this.idBarang,
    required this.jumlahTerjual,
    required this.tanggalTransaksi,
    required this.namaBarang,
    required this.stok,
    required this.idJenis,
    required this.jenisBarang,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        idTransaksi: json["id_transaksi"],
        idBarang: json["id_barang"],
        jumlahTerjual: json["jumlah_terjual"],
        tanggalTransaksi: DateTime.parse(json["tanggal_transaksi"]),
        namaBarang: json["nama_barang"],
        stok: json["stok"],
        idJenis: json["id_jenis"],
        jenisBarang: json["jenis_barang"],
      );

  Map<String, dynamic> toJson() => {
        "id_transaksi": idTransaksi,
        "id_barang": idBarang,
        "jumlah_terjual": jumlahTerjual,
        "tanggal_transaksi": tanggalTransaksi.toIso8601String(),
        "nama_barang": namaBarang,
        "stok": stok,
        "id_jenis": idJenis,
        "jenis_barang": jenisBarang,
      };
}
