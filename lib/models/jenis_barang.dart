import 'dart:convert';

List<JenisBarang> jenisBarangFromJson(String str) => List<JenisBarang>.from(
    json.decode(str).map((x) => JenisBarang.fromJson(x)));

String jenisBarangToJson(List<JenisBarang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JenisBarang {
  int idJenis;
  String jenisBarang;

  JenisBarang({
    required this.idJenis,
    required this.jenisBarang,
  });

  factory JenisBarang.fromJson(Map<String, dynamic> json) => JenisBarang(
        idJenis: json["id_jenis"],
        jenisBarang: json["jenis_barang"],
      );

  Map<String, dynamic> toJson() => {
        "id_jenis": idJenis,
        "jenis_barang": jenisBarang,
      };
}
