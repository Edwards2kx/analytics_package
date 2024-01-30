// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
/// Clase para obtener la información de los dispositivos conectados por bluetooth
class BTDeviceInfo {

/// Constructor de la clase Bluetooth device info, requiere el atributo MAC y services.
  BTDeviceInfo({
    required this.uuid,
    required this.name,
  });

///Dirección MAC del dispositivo bluetooth 
  String uuid;
///Servicios que ofrece el dispositivo, en lista de String, separados por ','.
  String name;

/////////////////////////////////////////////////////////////////////////////////////

///Metodo para serializar la clase, en un mapa de String, dynamic.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
    };
  }
  ///Metodo que devuelve en formato Json una representación de la clase con sus atributos.
  String toJson() => json.encode(toMap());

  @override
  String toString() => 'BluetoothDevice(uuid: $uuid, name: $name)';
}
