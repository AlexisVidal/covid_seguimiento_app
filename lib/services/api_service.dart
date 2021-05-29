import 'package:covid_seguimiento_app/model/login_model.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';
// import 'package:convert/convert.dart';
import 'dart:convert';

class ApiServices {
  static var client = http.Client();
  static String apiURL = '';
  static String apiURLV = 'http://192.168.1.3:5000';
  static String apiURLC = 'http://192.168.1.3:9000';

  static Future<bool> loginEmpleado(
      String username, String password, String empresa) async {
    if (empresa.trim().toUpperCase() == 'VILOCRU SAC') {
      apiURL = apiURLV;
    } else {
      apiURL = apiURLC;
    }

    String encoded = base64.encode(utf8.encode(password));
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded'
    };

    var response = await client.post(Uri.parse("$apiURL/Usuario/loginflutter"),
        headers: requestHeaders,
        body: {"IDUSUARIO": username, "PASSWORD": encoded});

    if (response.statusCode == 200) {
      List<Data> DataObjectList;
      var jsonString = response.body;
      if (jsonString == '[]') {
        return false;
      }
      print(response.body);
      var respons = jsonDecode(response.body);
      DataObjectList =
          (respons as List).map((data) => new Data.fromJson(data)).toList();
      if (DataObjectList.any((element) => true)) {
        Variables.isLogged = true;
        Variables.empresa = empresa;
        Variables.dni = DataObjectList[0].IDCODIGOGENERAL;
        Variables.nombres = DataObjectList[0].NOMBRES;
        Variables.apellidoPaterno = DataObjectList[0].A_PATERNO;
        Variables.apellidoMaterno = DataObjectList[0].A_MATERNO;
      } else {
        Variables.isLogged = false;
        Variables.empresa = empresa;
        Variables.dni = '';
        Variables.nombres = '';
        Variables.apellidoPaterno = '';
        Variables.apellidoMaterno = '';
      }

      //LoginResponseModel responseModel = loginResponseFromJson(jsonString);
      return true;
    }
    Variables.isLogged = false;
    Variables.empresa = empresa;
    Variables.dni = '';
    Variables.nombres = '';
    Variables.apellidoPaterno = '';
    Variables.apellidoMaterno = '';
    return false;
  }
   static Future<bool> updatePass(
      String passwordold, String password, String empresa) async {
        return true;
      }
}
