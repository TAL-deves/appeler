import 'package:data_management/core.dart';

import '../../../../index.dart';

class LocalUserDataSource extends LocalDataSourceImpl<AuthInfo> {
  LocalUserDataSource({
    super.path = "users",
    super.database,
  });

  @override
  AuthInfo build(source) => AuthInfo.from(source);
}
