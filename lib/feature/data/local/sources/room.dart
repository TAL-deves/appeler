import 'package:data_management/core.dart';

import '../../../../index.dart';

class LocalMeetingDataSource extends LocalDataSourceImpl<Meeting> {
  LocalMeetingDataSource({
    super.path = ApiKeys.meetings,
    super.database,
  });

  @override
  Meeting build(source) {
    return Meeting.from(source);
  }
}
