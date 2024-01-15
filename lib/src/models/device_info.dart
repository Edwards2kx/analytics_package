import 'dart:convert';

///Clase para representar información obtenida del hardware del dispositivo.
class DeviceInfo {
///Constructor de la clase [DeviceInfo]
  DeviceInfo(
      {required this.operativeSystem,
      required this.soVersion,
      required this.manufacturer,
      required this.model,
      required this.cpu,
      required this.isPhysicalDevice,
      this.identifier,
      this.totalStorage,
      this.freeStorage,
      this.ramSize});

  ///Sistema operativo, ios o android.
  String operativeSystem; //ios or android only

  ///Version del sistema operativo.
  String soVersion;

  ///Fabricante del dispositivo, siempre retorna apple para dispositivos ios.
  String manufacturer; // apple or android manufacturer

  ///Modelo del dispositivo, Ejemplo: iphone SE or Pixel 2xl
  String model; //iphone SE or Pixel 2xl

  ///Cpu del dispositivo, Ejemplo:
  String cpu;

  ///Identificador unico del dispositivo, en ios retorna el identificador asignado por apple
  ///en android devuelve un UUID generado.
  String? identifier;

  ///Almacenamiento total del dispositivo en MB.
  double? totalStorage;

  ///Almacenamiento libre del dispositivo en MB.
  double? freeStorage;

  ///Memoria RAM total del dispositivo.
  int? ramSize;

  ///Valor booleano que informa si el equipo es un dispositvo fisico o un emulador/simulador.
  bool isPhysicalDevice;

///Metodo para serializar la clase, en un mapa de String, dynamic.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'operative_system': operativeSystem,
      'so_version': soVersion,
      'manufacturer': manufacturer,
      'model': model,
      'cpu': cpu,
      'identifier': identifier,
      'total_storage': totalStorage,
      'free_storage': freeStorage,
      'ram_size': ramSize,
      'is_physical_device': isPhysicalDevice,
    };
  }

  ///Metodo que devuelve en formato Json una representación de la clase con sus atributos.
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'DeviceData(operativeSystem: $operativeSystem, soVersion: $soVersion, manufacturer: $manufacturer, model: $model, cpu: $cpu, identifier: $identifier, totalStorage: $totalStorage, freeStorage: $freeStorage, ramSize: $ramSize, isPhysicalDevice: $isPhysicalDevice)';
  }
}
