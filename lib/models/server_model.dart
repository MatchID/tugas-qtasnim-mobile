import 'dart:convert';

ServerModel serverModelFromJson(String str) =>
    ServerModel.fromJson(json.decode(str));

String serverModelToJson(ServerModel data) => json.encode(data.toJson());

class ServerModel {
  ServerModel({
    this.success,
    this.message,
    this.data,
    this.time,
  });

  bool? success;
  String? message;
  Data? data;
  Time? time;

  factory ServerModel.fromJson(Map<String, dynamic> json) => ServerModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        time: Time.fromJson(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data!.toJson(),
        "time": time!.toJson(),
      };
}

class Data {
  Data({
    this.update,
    this.login,
    this.access,
  });

  Update? update;
  Login? login;
  Access? access;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        update: Update.fromJson(json["update"]),
        login: Login.fromJson(json["login"]),
        access: Access.fromJson(json["access"]),
      );

  Map<String, dynamic> toJson() => {
        "update": update!.toJson(),
        "login": login!.toJson(),
        "access": access!.toJson(),
      };
}

class Access {
  Access({
    this.status,
    this.loadErrorStatus,
    this.inetPositifStatus,
    this.baseurl,
    this.adsBlock,
    this.loadError,
    this.inetPositif,
    this.waService,
    this.forceReview,
    this.tgService,
  });

  bool? status;
  bool? forceReview;
  bool? inetPositifStatus;
  bool? loadErrorStatus;
  String? baseurl;
  List<String>? adsBlock;
  LoadError? loadError;
  InetPositif? inetPositif;
  WaService? waService;
  TgService? tgService;

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        status: json["status"],
        inetPositifStatus: json["inet_positif_status"],
        loadErrorStatus: json["load_error_status"],
        forceReview: json["force_review"],
        baseurl: json["baseurl"],
        adsBlock: List<String>.from(json["ads_block"].map((x) => x)),
        loadError: LoadError.fromJson(json["load_error"]),
        inetPositif: InetPositif.fromJson(json["inet_positif"]),
        waService: WaService.fromJson(json["wa_service"]),
        tgService: TgService.fromJson(json["tg_service"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "inet_positif_status": inetPositifStatus,
        "load_error_status": loadErrorStatus,
        "force_review": forceReview,
        "baseurl": baseurl,
        "ads_block": List<dynamic>.from(adsBlock!.map((x) => x)),
        "load_error": loadError!.toJson(),
        "inet_positif": inetPositif!.toJson(),
        "wa_service": waService!.toJson(),
        "tg_service": tgService!.toJson(),
      };
}

class InetPositif {
  InetPositif({
    this.appDns,
    this.dns,
    this.vpn,
    this.paramBlock,
  });

  String? appDns;
  Dns? dns;
  Vpn? vpn;
  List<String>? paramBlock;

  factory InetPositif.fromJson(Map<String, dynamic> json) => InetPositif(
        appDns: json["app_dns"],
        dns: Dns.fromJson(json["dns"]),
        vpn: Vpn.fromJson(json["vpn"]),
        paramBlock: List<String>.from(json["param"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "app_dns": appDns,
        "dns": dns!.toJson(),
        "vpn": vpn!.toJson(),
        "param": List<dynamic>.from(paramBlock!.map((x) => x)),
      };
}

class Dns {
  Dns({
    this.dns1,
    this.dns2,
  });

  String? dns1;
  String? dns2;

  factory Dns.fromJson(Map<String, dynamic> json) => Dns(
        dns1: json["dns1"],
        dns2: json["dns2"],
      );

  Map<String, dynamic> toJson() => {
        "dns1": dns1,
        "dns2": dns2,
      };
}

class Vpn {
  Vpn({
    this.status,
    this.name,
    this.type,
    this.server,
    this.uname,
    this.pass,
    this.secret,
  });

  bool? status;
  String? name;
  String? type;
  String? server;
  String? uname;
  String? pass;
  String? secret;

  factory Vpn.fromJson(Map<String, dynamic> json) => Vpn(
        status: json["status"],
        name: json["name"],
        type: json["type"],
        server: json["server"],
        uname: json["uname"],
        pass: json["pass"],
        secret: json["secret"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "name": name,
        "type": type,
        "server": server,
        "uname": uname,
        "pass": pass,
        "secret": secret,
      };
}

class LoadError {
  LoadError({
    this.code,
    this.parameter,
  });

  List<int>? code;
  List<String>? parameter;

  factory LoadError.fromJson(Map<String, dynamic> json) => LoadError(
        code: List<int>.from(json["code"].map((x) => x)),
        parameter: List<String>.from(json["parameter"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": List<dynamic>.from(code!.map((x) => x)),
        "parameter": List<dynamic>.from(parameter!.map((x) => x)),
      };
}

class TgService {
  String? botA;
  String? botB;
  String? botC;
  String? chatId;
  String? decode;

  TgService({this.botA, this.botB, this.botC, this.chatId, this.decode});

  factory TgService.fromJson(Map<String, dynamic> json) => TgService(
        botA: json["bot_a"],
        botB: json["bot_b"],
        botC: json["bot_c"],
        chatId: json["chat_id"],
        decode: json["decode"],
      );

  Map<String, dynamic> toJson() => {
        "bot_a": botA,
        "bot_b": botB,
        "bot_c": botC,
        "chat_id": chatId,
        "decode": decode,
      };
}

class WaService {
  String? nomor;
  String? url;
  String? urlKey;
  String? token;
  String? username;
  String? sender;

  WaService(
      {this.nomor,
      this.url,
      this.urlKey,
      this.token,
      this.username,
      this.sender});

  factory WaService.fromJson(Map<String, dynamic> json) => WaService(
        nomor: json["nomor"],
        url: json["url"],
        urlKey: json["url_key"],
        token: json["token"],
        username: json["username"],
        sender: json["sender"],
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "url": url,
        "url_key": urlKey,
        "token": token,
        "sender": sender,
        "username": username,
      };
}

class Login {
  Login({
    this.status,
    this.url,
  });

  bool? status;
  String? url;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        status: json["status"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "url": url,
      };
}

class Update {
  Update({
    this.status,
    this.package,
  });

  bool? status;
  String? package;

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        status: json["status"],
        package: json["package"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "package": package,
      };
}

class Time {
  Time({
    this.updated,
    this.current,
    this.diff,
  });

  int? updated;
  int? current;
  String? diff;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        updated: json["updated"],
        current: json["current"],
        diff: json["diff"],
      );

  Map<String, dynamic> toJson() => {
        "updated": updated,
        "current": current,
        "diff": diff,
      };
}
