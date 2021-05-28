import 'package:covid_seguimiento_app/pages/historial_page.dart';
import 'package:covid_seguimiento_app/pages/perfil_page.dart';
import 'package:covid_seguimiento_app/pages/registro_page.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  var dni = Variables.dni;
  var nombres = Variables.nombres +
      ' ' +
      Variables.apellidoPaterno +
      ' ' +
      Variables.apellidoMaterno;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = 
  [
    RegistroPage(),
    HistorialPage(),
    PerfilPage()
  ];
  
  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bienvenido",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                Variables.isLogged = false;
                Variables.dni = '';
                Variables.nombres = '';
                Variables.apellidoPaterno = '';
                Variables.apellidoMaterno = '';
                Navigator.of(context).pushReplacementNamed('/login');
              }),
          SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
