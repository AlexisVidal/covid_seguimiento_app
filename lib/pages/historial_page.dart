import 'package:covid_seguimiento_app/model/seguimiento_model.dart';
import 'package:covid_seguimiento_app/services/ProgressHUD.dart';
import 'package:covid_seguimiento_app/services/api_service.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  var empresaselected = Variables.empresa;
  bool isApiCallProcess = false;
  List<SeguimientoModel> listaHistorial = Variables.listaHistorial;

  @override
  void initState() {
    //getHistorial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldkey,
        body: ProgressHUD(
          child: _historialUISetup(context),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _historialUISetup(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(key: globalFormKey, child: _historialUI(context)),
      ),
    );
  }

  Widget _historialUI(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Text(
                "Historial de registros",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: listaHistorial != null
                  ? Flexible(
                      child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listaHistorial.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(listaHistorial[index].toString()),
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child:
                                Icon(Icons.list_alt, color: Colors.amberAccent),
                          ),
                          direction: DismissDirection.endToStart,
                          child: Card(
                            elevation: 15,
                            child: Container(
                              height: 130.0,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 130.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            topLeft: Radius.circular(5)),
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: new AssetImage(
                                                'assets/images/icon.jpg'))),
                                  ),
                                  Container(
                                    height: 130.0,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              'Fecha registro: ' +
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(
                                                          listaHistorial[index]
                                                              .fecha_registro)
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            child: Text(
                                              'Estado de salud: ' +
                                                  listaHistorial[index]
                                                      .sensacion
                                                      .toString(),
                                              style: TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            child: Text(
                                              'Sintomas: ' +
                                                  listaHistorial[index]
                                                      .sintomas
                                                      .replaceAll('{', '')
                                                      .replaceAll('}', '')
                                                      .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            child: Text(
                                              'Prueba COVID: ' +
                                                  listaHistorial[index]
                                                      .prueba_covid
                                                      .toString(),
                                              style: TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            child: Text(
                                              'Fecha prueba: ' +
                                                  listaHistorial[index]
                                                      .fecha_prueba
                                                      .replaceAll(
                                                          ' 00:00:00.000', '')
                                                      .toString(),
                                              style: TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Padding(
                                          //     padding: EdgeInsets.fromLTRB(
                                          //         0, 3, 0, 3),
                                          //     child: FlatButton(
                                          //       textColor:
                                          //           Colors.red, // foreground
                                          //       onPressed: () {},
                                          //       child: Text(
                                          //           'FlatButton with custom foreground/background'),
                                          //     )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ))
                  : Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 40),
                          child: Text('No existe registros!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25))),
                    )),
        ]);
  }

  // getHistorial() async{
  //   listaHistorial = await ApiServices.getHistorial();
  // }
  openLocation(String location) async {
    double lat = 0;
    double long = 0;
    if (location == '') {
      final split = location.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      lat = double.parse(values[0]);
      long = double.parse(values[1]);
    }
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.launchMap(
        mapType: MapType.google,
        coords: Coords(lat, long),
        title: 'Registro',
        description: '',
      );
    }
  }
}
