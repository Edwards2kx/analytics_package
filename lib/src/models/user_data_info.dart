// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'bt_device_info.dart';
import 'device_info.dart';
import 'installed_app_info.dart';
import 'location_info.dart';
import 'wifi_network_info.dart';

class UserDataInfo {
  LocationInfo? location;
  List<WifiNetworkInfo>? wifiNetworkList;
  List<BTDeviceInfo>? btDeviceInfoList;
  DeviceInfo? deviceData;
  String? networkType;
  List<InstalledAppInfo>? installedAppList;
  
  UserDataInfo({
    this.location,
    this.wifiNetworkList,
    this.deviceData,
    this.networkType,
    this.btDeviceInfoList,
    this.installedAppList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location?.toMap(),
      'wifi_network_list': wifiNetworkList?.map((x) => x.toMap()).toList(),
      'device_data': deviceData?.toMap(),
      'network_type': networkType,
      'connected_devices_list':
          btDeviceInfoList?.map((x) => x.toMap()).toList(),
      'installed_app_list': installedAppList?.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserDataInfo(location: $location, wifiNetworkList: $wifiNetworkList, btDeviceInfoList: $btDeviceInfoList, deviceData: $deviceData, networkType: $networkType, installedAppList: $installedAppList)';
  }
}
