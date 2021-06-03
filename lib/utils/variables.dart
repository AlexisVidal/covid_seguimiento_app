import 'package:covid_seguimiento_app/model/seguimiento_model.dart';

class Variables {
  static var isLogged = false;
  static var username = "";
  static var empresa = "";
  static var dni = "";
  static var nombres = "";
  static var apellidoPaterno = "";
  static var apellidoMaterno = "";
  static var apiUrl = "";
  static List<SeguimientoModel> listaHistorial = new List<SeguimientoModel>();
}