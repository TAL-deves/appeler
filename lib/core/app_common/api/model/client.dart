import 'dart:convert' as converter;

class Client {
  final String? _id;

  String get id => _id ?? "";

  const Client({
    String? id,
  }) : _id = id;

  Client copy({
    String? id,
  }) {
    return Client(
      id: id ?? _id,
    );
  }

  factory Client.from(dynamic data) {
    var source = {};
    if (data is String) {
      source = converter.jsonDecode(data);
    }
    if (data is Map<String, dynamic>) {
      source = data;
    }
    return Client(
      id: source["id"],
    );
  }

  Map<String, dynamic> get source {
    return {
      "id": _id,
    };
  }

  String get json => converter.jsonEncode(source);
}
