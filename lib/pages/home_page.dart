import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  var dni = Variables.dni;
  var nombres = Variables.nombres +
      ' ' +
      Variables.apellidoPaterno +
      ' ' +
      Variables.apellidoMaterno;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trabajador - $nombres",
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
      body: Center(child: Text("Dashboard")),
    );
  }
}
