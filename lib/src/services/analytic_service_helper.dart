import 'dart:io';
import 'package:analytics/src/models/third_party_app_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:system_info_plus/system_info_plus.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:simpleblue/simpleblue.dart';

import '../models/bt_device_info.dart';
import '../models/device_info.dart';
import '../models/installed_app_info.dart';
import '../models/location_info.dart';
import '../models/wifi_network_info.dart';

class AnalyticServiceHelper {
  Future<DeviceInfo?> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final uuid = await DeviceUuid().getUUID();
      final diskSpace = await DiskSpacePlus.getTotalDiskSpace;
      final freeSpace = await DiskSpacePlus.getFreeDiskSpace;
      final ramSize = await SystemInfoPlus.physicalMemory;
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return DeviceInfo(
        identifier: uuid,
        cpu: androidInfo.board,
        manufacturer: androidInfo.manufacturer,
        model: androidInfo.model,
        operativeSystem: 'ANDROID',
        soVersion: androidInfo.version.release,
        isPhysicalDevice: androidInfo.isPhysicalDevice,
        totalStorage: diskSpace,
        freeStorage: freeSpace,
        ramSize: ramSize,
      );
    } else if (Platform.isIOS) {
      final diskSpace = await DiskSpacePlus.getTotalDiskSpace;
      final freeSpace = await DiskSpacePlus.getFreeDiskSpace;
      final ramSize = await SystemInfoPlus.physicalMemory;
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      final deviceData = DeviceInfo(
        identifier: iosInfo.identifierForVendor,
        cpu: '',
        manufacturer: 'Apple',
        model: iosInfo.model,
        operativeSystem: 'IOS',
        soVersion: iosInfo.systemVersion,
        isPhysicalDevice: iosInfo.isPhysicalDevice,
        totalStorage: diskSpace,
        freeStorage: freeSpace,
        ramSize: ramSize,
      );
      return deviceData;
    }
    return null;
  }

  Future<LocationInfo?> getUserLocation() async {
    //check for permission, if denied just report null dont try to get permission
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      try {
        final poiInfo = await Geolocator.getCurrentPosition();
        
        LocationInfo location = LocationInfo(
            latitute: poiInfo.latitude,
            longitude: poiInfo.longitude,
            altitude: poiInfo.altitude,
            timeStamp: poiInfo.timestamp,
            isMocked: poiInfo.isMocked);

        //Hace uso del paquete Geocoding para obtener la info
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              poiInfo.latitude, poiInfo.longitude);
          if (placemarks.isNotEmpty) {

            location.administrativeArea = placemarks[0].administrativeArea;
            location.country = placemarks[0].country;
            location.locality = placemarks[0].locality;

            print('placemark info \n ${placemarks[0]}');
          }
        } catch (e) {
          debugPrint('error $e');
        }
        return location;
      } catch (e) {
        debugPrint('error $e');
      }
    } else {
      debugPrint('Location permission may denied $locationPermission');
    }
    return null;
  }

  Future<String> getNetworkType() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'mobile';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 'wifi';
    }
    return 'unknown';
  }

  Future<List<WifiNetworkInfo>?> getWifiNetworkInfo() async {
    List<WifiNetworkInfo> wifiNetworks = [];
    if (!Platform.isAndroid) return wifiNetworks;
    try {
      final wifiHunterResults = await WiFiHunter.huntWiFiNetworks;
      if (wifiHunterResults != null) {
        for (var wifiResult in wifiHunterResults.results) {
          final wifiNetwork = WifiNetworkInfo(
              ssid: wifiResult.ssid,
              bssid: wifiResult.bssid,
              timeStamp: DateTime.now().toIso8601String(),
              levelInDb: wifiResult.level,
              capabilities: wifiResult.capabilities,
              frequency: wifiResult.frequency,
              channelWidth: wifiResult.channelWidth);
          wifiNetworks.add(wifiNetwork);
        }
        return wifiNetworks;
      }
    } catch (e) {
      debugPrint('error $e');
    }
    return null;
  }

  Future<List<BTDeviceInfo>> getBTDevicesInfo() async {
    final simplebluePlugin = Simpleblue();
    final List<BTDeviceInfo> btScannedDevices = [];
    try {
      final devices = await simplebluePlugin.getDevices();
      final permision = await Geolocator.checkPermission();
      if (permision != LocationPermission.always &&
          permision != LocationPermission.whileInUse) return [];

      //Si el bt está apagado lo enciende momentaneamente
      final blueIsOn = await simplebluePlugin.isTurnedOn() ?? false;
      if (!blueIsOn) {
        simplebluePlugin.turnOn();
      }
      for (var device in devices) {
        btScannedDevices.add(
          BTDeviceInfo(uuid: device.uuid, name: device.name ?? ''),
        );
      }
      //si estaba apagado lo vuelve a dejar como estaba
      if (!blueIsOn) {
        simplebluePlugin.turnOff();
      }
    } catch (e) {
      debugPrint('exception on bluetooth scan $e');
      return [];
    }

    return [];
  }

  Future<List<InstalledAppInfo>?> getInstalledAppsInfo(
      List<String>? thirdPartyAppsToLookUp) async {
    if (Platform.isAndroid) {
      List<Application> apps = await DeviceApps.getInstalledApplications();
      return apps
          .map(
            (app) => InstalledAppInfo(
                appName: app.appName,
                packageName: app.packageName,
                versionName: app.versionName),
          )
          .toList();
    } else if (Platform.isIOS) {
      //TODO: terminar el metodo
      return [];
    }
    return null;
  }

  Future<List<ThirdPartyAppItem>> getThirdPartyAppsInstalled(
      List<String>? thirdPartyAppsAndroid) async {
    if (thirdPartyAppsAndroid == null || thirdPartyAppsAndroid.isEmpty) {
      return [];
    }
    List<ThirdPartyAppItem> installedApps = [];
    //* si es android
    if (Platform.isAndroid) {
      for (var package in thirdPartyAppsAndroid) {
        final isInstalled =
            await LaunchApp.isAppInstalled(androidPackageName: package);
        installedApps.add(
          ThirdPartyAppItem(packageName: package, isInstalled: isInstalled),
        );
      }
    } else if (Platform.isIOS) {
      //TODO terminar metodo, requiere listado de aplicaciones de ios
    }
    return installedApps;
  }
}
