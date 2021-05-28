import 'package:covid_seguimiento_app/pages/login_page.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pages/home_page.dart';

Widget _defaultHome = new LoginPage();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await Variables.isLogged;
  if(_result){
    _defaultHome = new HomePage();
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seguimiento Covid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.amberAccent[700],
        accentColor: Colors.cyan[600]
      ),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/login': (BuildContext context) => new LoginPage()
      }
    );
  }
}