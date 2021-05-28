import 'package:flutter/material.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Historial"),
      ),
      body: Center(
        child: Text("Historiales"),
      ),
    );
  }
}