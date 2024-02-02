import 'package:analytics/src/data/http_client.dart';
import 'package:analytics/src/models/config_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('server request', () {
    //Asegurate de colocar el host adecuado para realizar el test
    const String host = 'http://127.0.0.1:8000';
    final client = CustomHttpClient(host: host);
    const analyticInfo = '''
      {
        "unique_id": "4b99efc6e3240e006b31adbf8c56fb199c720b9f",
        "user_data": {
          "location": {
            "latitute": 37.4219983,
            "longitude": -122.084,
            "altitude": 5.0,
            "is_mocked": false,
            "time_stamp": 1704284007139,
            "country": "United States",
            "administrative_area": "California",
            "locality": "Mountain View"
          },
          "wifi_network_list": [
            {
              "ssid": "AndroidWifi",
              "bssid": "00:13:10:85:fe:01",
              "time_stamp": "2024-01-03T07:13:31.177250",
              "level_in_db": -50,
              "capabilities": "[ESS]",
              "frequency": 2447,
              "channel_width": 0
            }
          ],
          "device_data": {
            "operative_system": "ANDROID",
            "so_version": "13",
            "manufacturer": "Google",
            "model": "sdk_gphone64_arm64",
            "cpu": "goldfish_arm64",
            "identifier": "4b99efc6e3240e006b31adbf8c56fb199c720b9f",
            "total_storage": 5939.59375,
            "free_storage": 2840.26953125,
            "ram_size": 1962,
            "is_physical_device": false
          },
          "network_type": "wifi",
          "bt_device_list": [],
          "installed_app_list": []
        }
      }
      ''';
    test('get config info from server', () async {
      //Arrange
      //Act
      final response = await client.getRequest();
      final configAnalytics = ConfigAnalytics.fromJson(response!);
      //Assert
      expect(configAnalytics.androidAppsPackageName, isA<List<String>>());
    });

    test('send info to server', () async {
      //Arrange
      const jsonBody = analyticInfo;
      //Act
      final response = await client.postRequest(jsonBody);
      //Assert
      expect(response, isTrue);
    });

    test('decode third party apps', () async {
        final response = await client.getRequest();
        if (response == null) return null;
         final configAnalytics = ConfigAnalytics.fromJson(response);
        debugPrint('${configAnalytics.androidAppsPackageName}');
        expect(configAnalytics.androidAppsPackageName.length, greaterThan(0));

    });
  });
}
