import 'package:data_management/core.dart';

import '../../../../index.dart';

class RemoteMeetingDataSource extends FireStoreDataSourceImpl<Meeting> {
  RemoteMeetingDataSource({
    super.path = ApiKeys.meetings,
  });

  @override
  Meeting build(source) {
    return Meeting.from(source);
  }
}
