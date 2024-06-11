class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchException extends AppException {
  FetchException([String? message]) : super(message, "");
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Kesalahan: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Permintaan Tidak Valid: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, "Input tidak valid: ");
}
