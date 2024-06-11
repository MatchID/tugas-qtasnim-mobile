import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/error_authorized.dart';
import 'app_exception.dart';

class ApiProvider {
  final int rto = 60;
  final client = http.Client();

  String baseUrl() {
    final String _prod = "http://10.0.2.2:3000";
    return _prod;
  }

  Future<dynamic> get({required String url, String body = "-"}) async {
    var responseJson;

    try {
      final response =
          await client.get(Uri.parse(baseUrl() + url + "?" + body), headers: {
        "X-API-RS": "-",
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(Duration(seconds: rto));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchException("Tidak Ada Koneksi internet");
    } on TimeoutException {
      throw FetchException("Request Time Out");
    }
    return responseJson;
  }

  Future<dynamic> post({required String url, dynamic body}) async {
    var responseJson;

    try {
      final response =
          await client.post(Uri.parse(baseUrl() + url), body: body, headers: {
        "X-API-RS": "-",
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(Duration(seconds: rto));

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchException("Tidak Ada Koneksi internet");
    } on TimeoutException {
      throw FetchException("Request Time Out");
    }
    return responseJson;
  }

  Future<dynamic> postLoginData(
      {required String url,
      dynamic body,
      required String linkLoginStored}) async {
    try {
      await client.post(Uri.parse(linkLoginStored + url), body: body, headers: {
        "key": "-",
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(Duration(seconds: 60));
    } on SocketException {
      print("error: SocketException");
    } on TimeoutException {
      print("error: TimeoutException");
    }
  }

  Future<dynamic> put({required String url, dynamic body}) async {
    var responseJson;

    try {
      final response =
          await client.put(Uri.parse(baseUrl() + url), body: body, headers: {
        "X-API-RS": "-",
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(Duration(seconds: rto));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchException("Tidak Ada Koneksi internet");
    } on TimeoutException {
      throw FetchException("Request Time Out");
    }
    return responseJson;
  }

  Future<dynamic> delete({required String url}) async {
    var apiResponse;

    try {
      final response =
          await client.delete(Uri.parse(baseUrl() + url), headers: {
        "X-API-RS": "-",
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(Duration(seconds: rto));
      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchException("Tidak Ada Koneksi internet");
    } on TimeoutException {
      throw FetchException("Request Time Out");
    }
    return apiResponse;
  }

  Future<dynamic> patch({required String url, dynamic body}) async {
    var apiResponse;

    try {
      final response =
          await client.patch(Uri.parse(baseUrl() + url), body: body, headers: {
        "X-API-RS": "-",
        HttpHeaders.contentTypeHeader: "application/json",
      }).timeout(Duration(seconds: rto));
      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchException("Tidak Ada Koneksi internet");
    } on TimeoutException {
      throw FetchException("Request Time Out");
    }
    return apiResponse;
  }

  dynamic _returnResponse(http.Response response) async {
    // print("CEKDATA --- >>>> " + response.statusCode.toString());
    // print("CEKDATA --- >>>> " + response.body.toString());

    switch (response.statusCode) {
      case 200:
        return response.body.toString();
      case 400:
        final result = errorAuthorizedFromJson(response.body.toString());
        throw BadRequestException(
            result.message + ' - CER${response.statusCode}');
      case 401:
        final result = errorAuthorizedFromJson(response.body.toString());
        throw BadRequestException(
            result.message + ' - CER${response.statusCode}');
      case 403:
        final result = errorAuthorizedFromJson(response.body.toString());
        throw InvalidInputException(
            result.message + ' - CER${response.statusCode}');
      case 404:
        final result = errorAuthorizedFromJson(response.body.toString());
        throw FetchException(result.message);
      case 500:
        throw FetchException("Server Error" + ' - SRV${response.statusCode}');
      case 502:
        throw FetchException("Server Error" + ' - SRV${response.statusCode}');
      case 503:
        throw FetchException("Server Error" + ' - SRV${response.statusCode}');
      default:
        throw FetchException("Server Error" + ' - APP${response.statusCode}');
    }
  }
}
