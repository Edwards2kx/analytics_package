import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:system_info_plus/system_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:simpleblue/simpleblue.dart';

import '../models/bt_device_info.dart';
import '../models/device_info.dart';
import '../models/installed_app_info.dart';
import '../models/location_info.dart';
import '../models/wifi_network_info.dart';

class AnalyticServiceHelper {
  ///Este metodo obtiene la información relacionada al dispositivo donde se ejecuta la app,
  ///no requiere permisos especiales.
  Future<DeviceInfo?> getDeviceInfo({bool showLogs = false}) async {
    if (!Platform.isAndroid && !Platform.isIOS) return null;

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final uuid = await DeviceUuid().getUUID();
      final diskSpace = await DiskSpacePlus.getTotalDiskSpace;
      final freeSpace = await DiskSpacePlus.getFreeDiskSpace;
      final ramSize = await SystemInfoPlus.physicalMemory;
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return DeviceInfo(
        deviceId: uuid,
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
        deviceId: iosInfo.identifierForVendor,
        cpu: iosInfo.localizedModel,
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

  ///Este metodo devuelve información relacionada con la ubicación del dispositivo e información
  ///de la zona geografica , requiere permiso del permiso de ubicación.
  Future<LocationInfo?> getUserLocation({bool showLogs = false}) async {
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

        //Hace uso del paquete Geocoding para obtener la info en caso de no poderse usar
        //devuelve solo las coordenadas.
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              poiInfo.latitude, poiInfo.longitude);
          if (placemarks.isNotEmpty) {
            location.administrativeArea = placemarks[0].administrativeArea;
            location.country = placemarks[0].country;
            location.locality = placemarks[0].locality;

            // if (showLogs) debugPrint('placemark info \n ${placemarks[0]}');
            if (showLogs) debugPrint('placemark info \n $placemarks}');
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

  Future<String> getNetworkType({bool showLogs = false}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'mobile';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 'wifi';
    }
    return 'unknown';
  }

  ///Retorna una lista de redes WIFI cercanas al dispositivo.
  ///Solo es posible para sistemas Android, en caso de que sea sistemas IOS devuelve
  ///un arreglo vacío, actualmente la API no recibe esta información.
  Future<List<WifiNetworkInfo>?> getWifiNetworkInfo(
      {bool showLogs = false}) async {
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
            channelWidth: wifiResult.channelWidth,
          );
          wifiNetworks.add(wifiNetwork);
        }
        return wifiNetworks;
      }
    } catch (e) {
      debugPrint('excepción en [getWifiNetworkInfo] $e');
    }
    return null;
  }

  ///Retorna un listado de dispositivo Bluetooth enlazados al dispositivo previamente,
  ///si el modulo bluetooth está apagado, lo enciende momentaneamente obtiene la información
  ///y lo vuelve a apagar.
  ///requiere permiso de ubicación y de bluettooth.
  Future<List<BTDeviceInfo>> getBTDevicesInfo({bool showLogs = false}) async {
    final simplebluePlugin = Simpleblue();
    final List<BTDeviceInfo> btScannedDevices = [];

    try {
      final permision = await Geolocator.checkPermission();
      if (permision != LocationPermission.always &&
          permision != LocationPermission.whileInUse) return [];
      //Si el bt está apagado lo enciende momentaneamente
      final wasBlueOn = await simplebluePlugin.isTurnedOn() ?? false;
      if (!wasBlueOn) await simplebluePlugin.turnOn();

      final devices = await simplebluePlugin.getDevices();
      for (var device in devices) {
        btScannedDevices.add(
          BTDeviceInfo(uuid: device.uuid, name: device.name ?? ''),
        );
      }
      //si estaba apagado lo vuelve a dejar como estaba
      if (!wasBlueOn) await simplebluePlugin.turnOff();
      return btScannedDevices;
    } catch (e) {
      debugPrint('excepción en [getBTDevicesInfo] $e');
      return [];
    }
  }

  ///Metodo que devuelve un listado especifico de aplicaciones instaladas en el dispositivo.
  ///Para sistemas Android se usa el parametro [androidApps] para sistemas iOS se usa el listado
  ///de constantes
  Future<List<InstalledAppInfo>> getThirdPartyAppsInstalled(
      List<String> appsToSearch,
      {bool showLogs = false}) async {
    List<InstalledAppInfo> financialAppsInstalled = [];

    if (!Platform.isAndroid && !Platform.isIOS) return [];

    if (Platform.isAndroid) {
      List<Application> apps = await DeviceApps.getInstalledApplications();
      for (var package in apps) {
        if (appsToSearch.contains(package.packageName)) {
          financialAppsInstalled.add(
            InstalledAppInfo(packageName: package.packageName),
          );
          if (showLogs)
            debugPrint('se encontró ${package.packageName} en el movil');
        }
      }
      return financialAppsInstalled;
    }
    // es IOS
    for (var app in appsToSearch) {
      try {
        final String iosUrlSchema = '$app://';
        if (await canLaunchUrl(Uri.parse(iosUrlSchema))) {
          financialAppsInstalled.add(
            InstalledAppInfo(packageName: app),
          );
        }
        if (showLogs) debugPrint('se econtró $app en el movil');
      } catch (e) {
        debugPrint('excepción en metodo[getThirdPartyAppsInstalled] $e');
      }
    }
    return financialAppsInstalled;
  }
}
