
import 'dart:convert';

/// Solo para plataforma #Android
class WifiNetworkInfo {
  String ssid;
  String bssid;
  String timeStamp;
  int levelInDb;
  String capabilities;
  int frequency;
  int channelWidth;
  WifiNetworkInfo({
    required this.ssid,
    required this.bssid,
    required this.timeStamp,
    required this.levelInDb,
    required this.capabilities,
    required this.frequency,
    required this.channelWidth,
  });

  @override
  String toString() {
    return 'WifiNetwork(ssid: $ssid, bssid: $bssid, timeStamp: $timeStamp, levelInDb: $levelInDb, capabilities: $capabilities, frequency: $frequency, channelWidth: $channelWidth)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ssid': ssid,
      'bssid': bssid,
      'time_stamp': timeStamp,
      'level_in_db': levelInDb,
      'capabilities': capabilities,
      'frequency': frequency,
      'channel_width': channelWidth,
    };
  }

  String toJson() => json.encode(toMap());
}
