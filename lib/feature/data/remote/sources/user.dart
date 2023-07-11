import 'package:data_management/core.dart';

import '../../../../index.dart';

class RemoteUserDataSource extends FireStoreDataSourceImpl<User> {
  RemoteUserDataSource({
    super.path = ApiKeys.users,
  });

  @override
  User build(source) => User.from(source);
}
