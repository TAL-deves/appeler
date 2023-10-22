// To parse this JSON data, do
//
//     final validationResponse = validationResponsefromMap(jsonString);

import 'dart:convert';

ValidationResponse validationResponseFromStr(String str) => ValidationResponse.fromMap(json.decode(str));

String validationResponsetoMap(ValidationResponse data) => json.encode(data.toMap());

class ValidationResponse {
  final ValidationEncoded? encoded;
  final int? jrn;

  ValidationResponse({
    this.encoded,
    this.jrn,
  });

  factory ValidationResponse.fromMap(Map<String, dynamic> json) => ValidationResponse(
    encoded: json["encoded"] == null ? null : ValidationEncoded.fromMap(json["encoded"]),
    jrn: json["jrn"],
  );

  Map<String, dynamic> toMap() => {
    "encoded": encoded?.toMap(),
    "jrn": jrn,
  };
}

class ValidationEncoded {
  final ValidationData? data;
  final bool? isError;
  final ValidationError? error;

  ValidationEncoded({
    this.data,
    this.isError,
    this.error,
  });

  factory ValidationEncoded.fromMap(Map<String, dynamic> json) => ValidationEncoded(
    data: json["data"] == null ? null : ValidationData.fromMap(json["data"]),
    isError: json["isError"],
    error: json["error"] == null ? null : ValidationError.fromMap(json["error"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data?.toMap(),
    "isError": isError,
    "error": error?.toMap(),
  };
}

class ValidationData {
  final String? message;
  final ValidationDetails? details;

  ValidationData({
    this.message,
    this.details,
  });

  factory ValidationData.fromMap(Map<String, dynamic> json) => ValidationData(
    message: json["message"],
    details: json["details"] == null ? null : ValidationDetails.fromMap(json["details"]),
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "details": details?.toMap(),
  };
}

class ValidationDetails {
  final String? sdkname;
  final int? serialNumber;
  final String? appid;
  final String? token;
  final int? balance;
  final DateTime? validity;
  final String? userid;
  final String? plan;
  final String? sdkid;
  final List<ValidationFeature>? features;

  ValidationDetails({
    this.sdkname,
    this.serialNumber,
    this.appid,
    this.token,
    this.balance,
    this.validity,
    this.userid,
    this.plan,
    this.sdkid,
    this.features,
  });

  factory ValidationDetails.fromMap(Map<String, dynamic> json) => ValidationDetails(
    sdkname: json["sdkname"],
    serialNumber: json["serialNumber"],
    appid: json["appid"],
    token: json["token"],
    balance: json["balance"],
    validity: json["validity"] == null ? null : DateTime.parse(json["validity"]),
    userid: json["userid"],
    plan: json["plan"],
    sdkid: json["sdkid"],
    features: json["features"] == null ? [] : List<ValidationFeature>.from(json["features"]!.map((x) => ValidationFeature.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "sdkname": sdkname,
    "serialNumber": serialNumber,
    "appid": appid,
    "token": token,
    "balance": balance,
    "validity": validity?.toIso8601String(),
    "userid": userid,
    "plan": plan,
    "sdkid": sdkid,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toMap())),
  };
}

class ValidationFeature {
  final int? serial;
  final String? name;
  final bool? enabled;
  final String? id;

  ValidationFeature({
    this.serial,
    this.name,
    this.enabled,
    this.id,
  });

  factory ValidationFeature.fromMap(Map<String, dynamic> json) => ValidationFeature(
    serial: json["serial"],
    name: json["name"],
    enabled: json["enabled"],
    id: json["_id"],
  );

  Map<String, dynamic> toMap() => {
    "serial": serial,
    "name": name,
    "enabled": enabled,
    "_id": id,
  };
}

class ValidationError {
  ValidationError();

  factory ValidationError.fromMap(Map<String, dynamic> json) => ValidationError();

  Map<String, dynamic> toMap() => {};
}
