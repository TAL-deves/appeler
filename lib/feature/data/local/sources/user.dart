import 'package:flutter_andomie/core.dart';

class LocalUserDataSource extends LocalDataSourceImpl<AuthInfo> {
  LocalUserDataSource({
    super.path = "users",
    required super.db,
  });

  @override
  AuthInfo build(source) => AuthInfo.from(source);
}
