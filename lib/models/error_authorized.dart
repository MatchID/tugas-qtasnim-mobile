import 'dart:convert';

ErrorAuthorized errorAuthorizedFromJson(String str) =>
    ErrorAuthorized.fromJson(json.decode(str));

String errorAuthorizedToJson(ErrorAuthorized data) =>
    json.encode(data.toJson());

class ErrorAuthorized {
  ErrorAuthorized({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<dynamic> data;

  factory ErrorAuthorized.fromJson(Map<String, dynamic> json) =>
      ErrorAuthorized(
        code: json["code"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
