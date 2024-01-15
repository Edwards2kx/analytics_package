// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ThirdPartyAppItem {

final String packageName;
final bool isInstalled;
  ThirdPartyAppItem({required this.packageName, required this.isInstalled});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'package_name': packageName,
      'is_installed': isInstalled,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ThirdPartyAppItem(packageName: $packageName, isIstalled: $isInstalled)';
}
