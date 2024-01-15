import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class CustomHttpClient {
  final _clienteHttp = Client();

  ///Url del servidor donde se enviarán los datos de analitica.
  final String host;

  ///Constructor para la clase [CustomHttpClient] la cual se usará para enviar y recibir datos
  ///del servidor.
  CustomHttpClient({
    required this.host,
  });

  ///Metodo para realizar una consulta tipo GET al host configurado en el parametro [host].
  ///retorna [null], si el parametro [host] es invalido.
  ///retorna [null], si no se obtuvo un codigo 200 desde el servidor.
  ///en caso de exito en la consulta, retorna un String con el contenido del body 
  ///de la respuesta del servidor.
  Future<String?> getRequest() async {
    final Uri? uri = Uri.tryParse(host);
    if (uri == null) return null;
    final response = await _clienteHttp.get(uri);
    if (response.statusCode != 200) {
      debugPrint(
          'response code: ${response.statusCode} \nresponse body: ${response.body}');
      return null;
    }
    return response.body;
  }

  ///Metodo para realizar una consulta tipo POST al host configurado en el parametro [host] y envia
  ///un objeto tipo JSON recibido en el parametro [body].
  ///retorna [false], si el codigo de respuesta es diferente de 200 o 201.
  ///retorna [null], si el parametro [host] es invalido.
  ///retorna [true], si la operación fue exitosa, imprime por consola el body de la respuesta recibida.
  Future<bool?> postRequest([dynamic body]) async {
    final Uri? uri = Uri.tryParse(host);
    if (uri == null) return null;
    final response = await _clienteHttp.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
          'response code: ${response.statusCode} \nresponse body: ${response.body}');
      return false;
    }
    debugPrint(response.body);
    return true;
  }
}
