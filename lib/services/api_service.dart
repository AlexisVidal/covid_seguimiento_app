import 'dart:io';

import 'package:covid_seguimiento_app/model/login_model.dart';
import 'package:covid_seguimiento_app/model/seguimiento_model.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';
// import 'package:convert/convert.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class ApiServices {
  static var client = http.Client();
  static String apiURL = '';
  static String apiURLV = 'http://192.168.1.3:5000';
  static String ipapiURL = '192.168.1.3';
  static String apiURLC = 'http://192.168.1.3:9000';
  static String apiURLV2 = 'http://181.65.145.74:5000';
  static String ipapiURL2 = '181.65.145.74';
  static String apiURLC2 = 'http://181.65.145.74:9000';
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/x-www-form-urlencoded'
  };

  static Future<int> checkInternet(String empresa) async {
    int retorno = 1;
    try {
      if (empresa.trim().toUpperCase() == 'VILOCRU SAC') {
        apiURL = apiURLV;
      } else {
        apiURL = apiURLC;
      }
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        retorno=1;
        print('conectado');
      } else {
        retorno = 0;
      }
      
    } on SocketException catch (_) {
      print('not connected');
      retorno = 0;
    }
    return retorno;
  }

  static Future<bool> loginEmpleado(
      String username, String password, String empresa) async {
    int conexion = await checkInternet(empresa);
    if (conexion == 0) {
      return false;
    } else if (conexion == 1) {
      if (empresa.trim().toUpperCase() == 'VILOCRU SAC') {
        apiURL = apiURLV2;
      } else {
        apiURL = apiURLC2;
      }
    } else if (conexion == 2) {
      if (empresa.trim().toUpperCase() == 'VILOCRU SAC') {
        apiURL = apiURLV;
      } else {
        apiURL = apiURLC;
      }
    }

    String encoded = conviertePass(password);
Variables.apiUrl = apiURL;
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
        Variables.username = username;
        Variables.empresa = empresa;
        Variables.dni = DataObjectList[0].IDCODIGOGENERAL;
        Variables.nombres = DataObjectList[0].NOMBRES;
        Variables.apellidoPaterno = DataObjectList[0].A_PATERNO;
        Variables.apellidoMaterno = DataObjectList[0].A_MATERNO;
        Variables.listaHistorial = await getHistorial();
      } else {
        Variables.isLogged = false;
        Variables.username = "";
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
    Variables.username = "";
    Variables.empresa = empresa;
    Variables.dni = '';
    Variables.nombres = '';
    Variables.apellidoPaterno = '';
    Variables.apellidoMaterno = '';
    return false;
  }

  static Future<bool> updatePass(String username, String passwordold,
      String password, String empresa) async {
        String apiselected = Variables.apiUrl;
    var exist = await loginEmpleado(username, passwordold, empresa);
    if (exist) {
      String nuevapass = conviertePass(password);
      var response = await client.post(
          Uri.parse("$apiselected/Usuario/loginflutterupdate"),
          headers: requestHeaders,
          body: {"IDUSUARIO": username, "PASSWORD": nuevapass});

      if (response.statusCode == 200) {
        List<Data> listaUsuario;
        var jsonString = response.body;
        if (jsonString == '[]') {
          return false;
        }
        print(response.body);
        var respons = jsonDecode(response.body);
        listaUsuario =
            (respons as List).map((data) => new Data.fromJson(data)).toList();
        if (listaUsuario.any((element) => true)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static String conviertePass(String password) {
    String passencoded = base64.encode(utf8.encode(password));
    return passencoded;
  }

  static Future<bool> RegistroSeguimiento(
      String fecha_registro,
      String ubicacion,
      String sensacion,
      String sintomas,
      String prueba_covid,
      String fecha_prueba,
      String contacto_covid,
      String empresa) async {
    // if (empresa.trim().toUpperCase() == 'VILOCRU SAC') {
    //   apiURL = apiURLV;
    // } else {
    //   apiURL = apiURLC;
    // }
    String apiselected = Variables.apiUrl;
    var idcodigogeneral = Variables.dni;

    var fechahoy = DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd-MM-yyyy').parse(fecha_registro));
    //  DateTime fechahoy = HttpDate.parse(fecha_registro);
    var response = await client.post(
        Uri.parse("$apiselected/Seguimiento/t_segumientoInsert"),
        headers: requestHeaders,
        body: {
          "IDCODIGOGENERAL": idcodigogeneral,
          "fecha_registro": fechahoy,
          "ubicacion": ubicacion,
          "sensacion": sensacion,
          "sintomas": sintomas,
          "prueba_covid": prueba_covid,
          "fecha_prueba": fecha_prueba,
          "contacto_covid": contacto_covid
        });

    if (response.statusCode == 200) {
      List<SeguimientoModel> lista;
      var jsonString = response.body;
      if (jsonString == '[]') {
        return false;
      }
      print(response.body);
      var respons = jsonDecode(response.body);
      lista = (respons as List)
          .map((data) => new SeguimientoModel.fromJson(data))
          .toList();
      if (lista.any((element) => true)) {
        Variables.listaHistorial = await getHistorial();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<List<SeguimientoModel>> getHistorial() async {
    var idcodigogeneral = Variables.dni;
    var empresa = Variables.empresa;
    // if (empresa.trim().toUpperCase() == 'VILOCRU SAC') {
    //   apiURL = apiURLV;
    // } else {
    //   apiURL = apiURLC;
    // }
    String apiselected = Variables.apiUrl;
    var response = await client.post(
        Uri.parse("$apiselected/Seguimiento/t_seguimientoSelect"),
        headers: requestHeaders,
        body: {"IDCODIGOGENERAL": idcodigogeneral});
    if (response.statusCode == 200) {
      List<SeguimientoModel> lista;
      var jsonString = response.body;
      if (jsonString == '[]') {
        return null;
      }
      print(response.body);
      var respons = jsonDecode(response.body);
      lista = (respons as List)
          .map((data) => new SeguimientoModel.fromJson(data))
          .toList();
      if (lista.any((element) => true)) {
        return lista;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
