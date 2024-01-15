import 'dart:convert';

class LocationInfo {
  double latitute;
  double longitude;
  double altitude;
  bool isMocked; //always false on iOS
  DateTime timeStamp;
  String? country;
  String? administrativeArea;
  String? locality;
  LocationInfo({
    required this.latitute,
    required this.longitude,
    required this.altitude,
    required this.isMocked,
    required this.timeStamp,
    this.country,
    this.administrativeArea,
    this.locality
  });

  @override
  String toString() {
    return 'UserLocation(latitute: $latitute, longitude: $longitude, altitude: $altitude, isMocked: $isMocked, timeStamp: $timeStamp, country: $country, administrativeArea: $administrativeArea, locality: $locality)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitute': latitute,
      'longitude': longitude,
      'altitude': altitude,
      'is_mocked': isMocked,
      'time_stamp': timeStamp.millisecondsSinceEpoch,
      'country': country,
      'administrative_area': administrativeArea,
      'locality': locality,
    };
  }
  String toJson() => json.encode(toMap());
}
