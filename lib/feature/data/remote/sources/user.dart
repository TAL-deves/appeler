import 'package:flutter_andomie/core.dart';

import '../../../../index.dart';

class RemoteUserDataSource extends FireStoreDataSourceImpl<AuthInfo> {
  RemoteUserDataSource({
    super.path = ApiKeys.users,
  });

  @override
  AuthInfo build(source) => AuthInfo.from(source);
}
