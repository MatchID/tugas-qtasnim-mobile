import 'dart:convert';

List<Comparation> comparationFromJson(String str) => List<Comparation>.from(
    json.decode(str).map((x) => Comparation.fromJson(x)));

String comparationToJson(List<Comparation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comparation {
  String jenisBarang;
  int totalTerjual;

  Comparation({
    required this.jenisBarang,
    required this.totalTerjual,
  });

  factory Comparation.fromJson(Map<String, dynamic> json) => Comparation(
        jenisBarang: json["jenis_barang"],
        totalTerjual: json["total_terjual"],
      );

  Map<String, dynamic> toJson() => {
        "jenis_barang": jenisBarang,
        "total_terjual": totalTerjual,
      };
}
