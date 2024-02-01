// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'user_data_info.dart';

class InfoAnalytics {
  final UserDataInfo userData;

  final String? uniqueId;

  InfoAnalytics({
    required this.userData,
  }) : uniqueId = userData.deviceData?.deviceId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'unique_id': uniqueId,
      'user_data': userData.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
