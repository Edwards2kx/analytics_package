import 'dart:convert';

// para android e iOS
class InstalledAppInfo {
  final String? appName;
  final String packageName;
  final String? versionName;

  InstalledAppInfo({required this.packageName, this.appName, this.versionName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'app_name': appName,
      'package_name': packageName,
      'version_name': versionName,
    };
  }

  String toJson() => json.encode(toMap());
}
