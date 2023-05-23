import 'package:flutter_andomie/core.dart';

import '../../../../index.dart';

class UserDataSource extends FireStoreDataSourceImpl<AuthInfo> {
  UserDataSource({
    super.path = ApiKeys.users,
  });

  @override
  AuthInfo build(source) => AuthInfo.from(source);
}
