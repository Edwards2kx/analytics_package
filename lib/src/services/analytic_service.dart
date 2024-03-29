// ignore_for_file: avoid_print
import 'dart:io';

import 'package:analytics/src/models/config_analytics.dart';
import 'package:flutter/foundation.dart';
import '../constants/financial_apps_ios.dart';
import '../data/http_client.dart';
import '../models/info_analytics.dart';
import '../models/user_data_info.dart';
import 'analytic_service_helper.dart';

class AnalyticService {
  final bool _checkLocationInfo;
  final bool _checkWifiInfo;
  final bool _checkBtDevicesInfo;
  final bool _checkThirdPartyApps;
  final AnalyticServiceHelper _infoService = AnalyticServiceHelper();
  final CustomHttpClient _httpServer;
  final bool _showLogs;
  List<String> _thirdPartyAppsToLookUp = [];

  ///Parametro interno que indica si el servicio ya se encuentra en ejecución.
  bool _busyWorking = false;

  static AnalyticService? _instance;

  AnalyticService._internal(
      {required String host,
      String? serverKey,
      bool checkLocationInfo = true,
      bool checkWifiInfo = true,
      bool checkBtDevicesInfo = true,
      bool checkThirdPartyApps = true,
      bool showLogs = false})
      : _checkLocationInfo = checkLocationInfo,
        _checkWifiInfo = checkWifiInfo,
        _checkBtDevicesInfo = checkBtDevicesInfo,
        _checkThirdPartyApps = checkThirdPartyApps,
        _showLogs = showLogs,
        assert(host.isNotEmpty, 'Host parameter must not be empty'),
        assert(host.startsWith('http://') || host.startsWith('https://'),
            'Host parameter should start with the http or https schema'),
        _httpServer = CustomHttpClient(host: host);

  ///Clase AnalyticService para obtener datos de analitica del dispositivo y del usuario.
  ///requiere el parametro [host] que es el endpoint a donde se comunicará el servicio.
  ///
  ///retorna una instancia singletón que puede ser recuperada usando el metodo estático instance.
  ///
  factory AnalyticService.setup(
      {required String host,
      String? serverKey,
      bool checkLocationInfo = true,
      bool checkWifiInfo = true,
      bool checkBtDevicesInfo = true,
      bool checkThirdPartyApps = true,
      bool showLogs = false}) {
    _instance ??= AnalyticService._internal(
        host: host,
        serverKey: serverKey,
        checkLocationInfo: checkLocationInfo,
        checkWifiInfo: checkWifiInfo,
        checkBtDevicesInfo: checkBtDevicesInfo,
        checkThirdPartyApps: checkThirdPartyApps,
        showLogs: showLogs);
    return _instance!;
  }

  ///Devuelve la instancia de la clase [AnalyticService] inicializada con el constructor .setup,
  ///en caso de no haberse configurado previamente lanza un [assert] y retorna un [null].
  ///
  static AnalyticService? instance() {
    assert(_instance != null, 'AnalyticService.setup should be called first');
    return _instance;
  }

  ///Ejecuta la acción del servicio, de obtener información de configuración desde el servidor,
  ///capturar los datos de analitica del usuario y luego enviarlos al servidor.
  Future<bool> call() async {
    if (_busyWorking) return false;
    _busyWorking = true;
    bool? response = false;

    try {
      await _getConfigFromServer();
      final infoAnalytics = await _getInfoAnalytic();
      final requestBody = infoAnalytics?.toJson();
      if (_showLogs) {
        debugPrint('request body \n$requestBody');
      }
      response = await _httpServer.postRequest(requestBody);
    } catch (e) {
      debugPrint(e.toString());
      response = false;
    }
    _busyWorking = false;
    if (response == null) return false;
    return response;
  }

  ///Hace una llamada al servidor para obtener datos de configuración del servicio de analitica,
  ///recibe el listado de las apps que se revisará si están instaladas en el dispositivo Android.
  Future<void> _getConfigFromServer() async {
    try {
      final response = await _httpServer.getRequest();
      if (response == null) return;
      final configAnalytics = ConfigAnalytics.fromJson(response);
      _thirdPartyAppsToLookUp = configAnalytics.androidAppsPackageName;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Obtiene la información de analytica del dispositivo, hace uso de la clase [AnalyticServiceHelper].
  ///retorna un objeto [InfoAnalytics] con la información que será enviada al servidor.
  ///
  ///Hace uso de los valores booleanos de configuración en caso de que se quierá obtener solo parte de
  ///la analytica por motivos de permisos del usuario.
  Future<InfoAnalytics?> _getInfoAnalytic() async {
    final userData = UserDataInfo();
    try {
      userData.deviceData =
          await _infoService.getDeviceInfo(showLogs: _showLogs);

      userData.networkType =
          await _infoService.getNetworkType(showLogs: _showLogs);

      userData.location = _checkLocationInfo
          ? await _infoService.getUserLocation(showLogs: _showLogs)
          : null;

      userData.wifiNetworkList = _checkWifiInfo
          ? await _infoService.getWifiNetworkInfo(showLogs: _showLogs)
          : null;

      userData.btDeviceInfoList = _checkBtDevicesInfo
          ? await _infoService.getBTDevicesInfo(showLogs: _showLogs)
          : null;

      final List<String> appsToSearch = Platform.isIOS
          ? kIosAppUrlSchema
          : Platform.isAndroid
              ? _thirdPartyAppsToLookUp
              : [];

      userData.installedAppList = _checkThirdPartyApps
          ? await _infoService.getThirdPartyAppsInstalled(appsToSearch,
              showLogs: _showLogs)
          : null;

      // if (_checkThirdPartyApps) {
      //   List<String> appsToSearch = [];
      //   if (Platform.isIOS) appsToSearch = kIosAppUrlSchema;
      //   if (Platform.isAndroid) appsToSearch = _thirdPartyAppsToLookUp;
      //   userData.installedAppList = await _infoService
      //       .getThirdPartyAppsInstalled(appsToSearch, showLogs: _showLogs);
      // }

      final infoAnalytics = InfoAnalytics(userData: userData);
      return infoAnalytics;
    } catch (e) {
      if (_showLogs) debugPrint('Excepción en [_getInfoAnalytic] $e');
      return null;
    }
  }
}
