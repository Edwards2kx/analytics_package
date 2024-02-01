import 'dart:convert';

/// Esta clase recibe la configuración desde el servidor, donde actualmente solo
/// se recibe la lista de aplicaciones de terceros o apps financieras para ser
/// identificadas en sistemas Android.
/// 
class ConfigAnalytics {
  List<String> androidAppsPackageName = [];
  ConfigAnalytics({List<String>? androidAppsPackageName})
      : androidAppsPackageName = androidAppsPackageName ?? [];

  factory ConfigAnalytics.fromMap(Map<String, dynamic> map) {
    return ConfigAnalytics(
      androidAppsPackageName: List<String>.from(
        (map['android_apps_package_name']),
      ),
    );
  }

  factory ConfigAnalytics.fromJson(String source) =>
      ConfigAnalytics.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ConfigAnalytics(androidAppsPackageName: $androidAppsPackageName)';
}
