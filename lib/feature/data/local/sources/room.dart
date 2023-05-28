import 'package:flutter_andomie/core.dart';

import '../../../../index.dart';

class LocalMeetingDataSource extends LocalDataSourceImpl<Meeting> {
  LocalMeetingDataSource({
    super.path = ApiKeys.meetings,
    required super.db,
  });

  @override
  Meeting build(source) {
    return Meeting.from(source);
  }
}
