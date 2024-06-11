import 'dart:convert';

List<Barang> barangFromJson(String str) =>
    List<Barang>.from(json.decode(str).map((x) => Barang.fromJson(x)));

String barangToJson(List<Barang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Barang {
  int idBarang;
  String namaBarang;
  int stok;
  int idJenis;

  Barang({
    required this.idBarang,
    required this.namaBarang,
    required this.stok,
    required this.idJenis,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        idBarang: json["id_barang"],
        namaBarang: json["nama_barang"],
        stok: json["stok"],
        idJenis: json["id_jenis"],
      );

  Map<String, dynamic> toJson() => {
        "id_barang": idBarang,
        "nama_barang": namaBarang,
        "stok": stok,
        "id_jenis": idJenis,
      };
}
