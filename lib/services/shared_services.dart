import 'package:covid_seguimiento_app/model/empresa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService{
  static Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  // static Future<Data> loginDetails() async{

  // }

}