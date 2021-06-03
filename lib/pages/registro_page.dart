import 'package:covid_seguimiento_app/model/contacto_model.dart';
import 'package:covid_seguimiento_app/model/estado_model.dart';
import 'package:covid_seguimiento_app/model/prueba_model.dart';
import 'package:covid_seguimiento_app/model/sintoma_model.dart';
import 'package:covid_seguimiento_app/utils/custom_alert_dialog.dart';
import 'package:covid_seguimiento_app/utils/custom_dropdown.dart';
import 'package:covid_seguimiento_app/utils/my_text_field_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:covid_seguimiento_app/services/api_service.dart';
import 'package:covid_seguimiento_app/utils/form_helper.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:covid_seguimiento_app/services/ProgressHUD.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('dd-MM-yyyy');
String fechaHoy = formatter.format(now);

class _RegistroPageState extends State<RegistroPage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  var empresaselected = Variables.empresa;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String _fechaActual = "";
  String _fechaCovid = "";
  GoogleMapController mapController;
  LocationData _currentPosition;
  String _address, _dateTime;
  Marker marker;
  Location location = Location();

  GoogleMapController _controller;
  LatLng _initialcameraposition = const LatLng(-5.183284, -80.644605);
  BitmapDescriptor _markerIcon;

  Set<Marker> _markers = HashSet<Marker>();
  int _markerIdCounter = 1;
  bool _isMarker = false;
  String ubicacion = "";
  String estadosalud = "Bien";
  String pruevacovid = "No";
  String contactocovid = "No";

  List<SintomaModel> checkBoxListSintomaModel = SintomaModel.getSintomas();
  List<int> listaSintomas = new List<int>();
  final Set _saved = Set();
  final List<EstadoModel> _estadoModelList = [
    EstadoModel(nombreEstado: 'Bien', idEstado: 1),
    EstadoModel(nombreEstado: 'Con Malestar', idEstado: 2),
    EstadoModel(nombreEstado: 'Enfermo', idEstado: 3),
  ];
  EstadoModel _estadoModel = EstadoModel();
  List<DropdownMenuItem<EstadoModel>> _estadoModelDropdownList;
  List<DropdownMenuItem<EstadoModel>> _buildEstadoModelDropdown(
      List estadoModelList) {
    List<DropdownMenuItem<EstadoModel>> items = List();
    for (EstadoModel _estadoModel in estadoModelList) {
      items.add(DropdownMenuItem(
        value: _estadoModel,
        child: Text(_estadoModel.nombreEstado),
      ));
    }
    return items;
  }

  final List<PruebaModel> _pruebaModelList = [
    PruebaModel(nombrePrueba: 'No', idPrueba: 1),
    PruebaModel(nombrePrueba: 'Si, resulté negativo', idPrueba: 2),
    PruebaModel(nombrePrueba: 'Si, resulté positivo', idPrueba: 3),
  ];
  PruebaModel _pruebaModel = PruebaModel();
  List<DropdownMenuItem<PruebaModel>> _pruebaModelDropdownList;
  List<DropdownMenuItem<PruebaModel>> _buildPruebaModelDropdown(
      List pruebaModelList) {
    List<DropdownMenuItem<PruebaModel>> items = List();
    for (PruebaModel _pruebaModel in pruebaModelList) {
      items.add(DropdownMenuItem(
        value: _pruebaModel,
        child: Text(_pruebaModel.nombrePrueba),
      ));
    }
    return items;
  }

  final List<ContactoModel> _contactoModelList = [
    ContactoModel(nombreContacto: 'No', idContacto: 1),
    ContactoModel(nombreContacto: 'Si', idContacto: 2),
  ];
  ContactoModel _contactoModel = ContactoModel();
  List<DropdownMenuItem<ContactoModel>> _contactoModelDropdownList;
  List<DropdownMenuItem<ContactoModel>> _buildContactoModelDropdown(
      List contactoModelList) {
    List<DropdownMenuItem<ContactoModel>> items = List();
    for (ContactoModel _contactoModel in contactoModelList) {
      items.add(DropdownMenuItem(
        value: _contactoModel,
        child: Text(_contactoModel.nombreContacto),
      ));
    }
    return items;
  }

  @override
  void initState() {
    getLoc();
    _estadoModelDropdownList = _buildEstadoModelDropdown(_estadoModelList);
    _estadoModel = _estadoModelList[0];
    _pruebaModelDropdownList = _buildPruebaModelDropdown(_pruebaModelList);
    _pruebaModel = _pruebaModelList[0];
    _contactoModelDropdownList =
        _buildContactoModelDropdown(_contactoModelList);
    _contactoModel = _contactoModelList[0];
    super.initState();
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/point.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('0'),
          position: LatLng(-5.183284, -80.644605),
          infoWindow:
              InfoWindow(title: 'Roça', snippet: 'Um bom lugar para estar'),
          //icon: _markerIcon,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldkey,
        body: ProgressHUD(
          child: _registroUISetup(context),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _registroUISetup(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(key: globalFormKey, child: _registroUI(context)),
      ),
    );
  }

  Widget _registroUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 40),
            child: Text(
              "Nuevo registro de estado de salud",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 10, left: 40),
          child: Text(
            "Fecha de registro:",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: FormHelper.inputDateFieldWidget(
            context,
            Icon(Icons.date_range_sharp),
            "_fechaActual",
            "_fechaActual",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Valor de contraseña no puede estar vacio";
              }
              return null;
            },
            (onSavedValue) {
              _fechaActual = onSavedValue.toString().trim();
            },
            initialValue: fechaHoy,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 10, left: 40),
          child: Text(
            "Ubicacion: ",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 2.6,
                child: GoogleMap(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer())
                  ].toSet(),
                  mapType: MapType.satellite,
                  markers: _markers,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialcameraposition,
                    zoom: 17.0,
                  ),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 15, left: 40),
          child: Text(
            "Estado de salud",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40),
          child: Text(
            "¿Cómo te sientes?",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: CustomDropdown(
            dropdownMenuItemList: _estadoModelDropdownList,
            onChanged: _onChangeEstadoModelDropdown,
            value: _estadoModel,
            isEnabled: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40),
          child: Text(
            "Síntomas",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: checkBoxListSintomaModel.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                          activeColor: Colors.amberAccent,
                          dense: true,
                          //font change
                          title: new Text(
                            checkBoxListSintomaModel[index].title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                          value: checkBoxListSintomaModel[index].isCheck,
                          secondary: Container(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              checkBoxListSintomaModel[index].img,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onChanged: (bool val) {
                            //itemChange(val, index);
                            setState(() {
                              if (val == true) {
                                _saved
                                    .add(checkBoxListSintomaModel[index].title);
                              } else {
                                _saved.remove(
                                    checkBoxListSintomaModel[index].title);
                              }
                              checkBoxListSintomaModel[index].isCheck = val;
                              print(_saved);
                            });
                          })
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 15, left: 40),
          child: Text(
            "Evaluaciones",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40),
          child: Text(
            "¿Te has realizado la prueva Covid en los ultimos 14 dias?",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: CustomDropdown(
            dropdownMenuItemList: _pruebaModelDropdownList,
            onChanged: _onChangePruebaModelDropdown,
            value: _pruebaModel,
            isEnabled: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40),
          child: Text(
            "¿Cuando te hiciste el examen?",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: MyTextFieldDatePicker(
            labelText: "",
            prefixIcon:
                Icon(Icons.date_range, color: Theme.of(context).primaryColor),
            suffixIcon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor),
            lastDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 90)),
            initialDate: DateTime.now().subtract(Duration(days: 1)),
            onDateChanged: (selectedDate) {
              _fechaCovid = selectedDate.toString();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40),
          child: Text(
            "Has tenido contacto reciente con alguien con COVID 19 confirmado en los ultimos 14 dias?",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: CustomDropdown(
            dropdownMenuItemList: _contactoModelDropdownList,
            onChanged: _onChangeContactoModelDropdown,
            value: _contactoModel,
            isEnabled: true,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.saveButton(
            "Registrar",
            () {
              if (validateAndSave()) {
                // print("Pass Old: $_pwd");
                // print("Pass new: $_pwdn");
                setState(() {
                  this.isApiCallProcess = true;
                });
                var dialog = CustomAlertDialog(
                  title: "Registro",
                  message: "¿Está seguro de realizar el registro?",
                  onNegativePressed: () {
                    setState(() {
                      this.isApiCallProcess = false;
                    });
                  },
                  onPostivePressed: () {
                    ApiServices.RegistroSeguimiento(
                            _fechaActual,
                            ubicacion,
                            estadosalud,
                            _saved.toString(),
                            pruevacovid,
                            _fechaCovid,
                            contactocovid,
                            empresaselected)
                        .then((response) {
                      setState(() {
                        this.isApiCallProcess = false;
                      });
                      if (response) {
                            FormHelper.showMessage(
                                context, "Exito", "Se registró correctamente!", "Ok",
                                () {
                              Navigator.of(context).pop(true);
                              //Navigator.of(context).pushReplacementNamed('/home');
                            });

                      } else {
                        FormHelper.showMessage(
                            context, "Error", "Error en el registro!", "Ok",
                            () {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, "Perfil");
                  },
                  positiveBtnText: 'Si',
                  negativeBtnText: 'No',
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog);
              }
              return null;
            },
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _onChangeContactoModelDropdown(ContactoModel contactoModel) {
    setState(() {
      _contactoModel = contactoModel;
      contactocovid = _contactoModel.nombreContacto;
    });
  }

  _onChangePruebaModelDropdown(PruebaModel pruebaModel) {
    setState(() {
      _pruebaModel = pruebaModel;
      pruevacovid = _pruebaModel.nombrePrueba;
    });
  }

  _onChangeEstadoModelDropdown(EstadoModel estadoModel) {
    setState(() {
      _estadoModel = estadoModel;
      estadosalud = _estadoModel.nombreEstado;
    });
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      //print("${currentLocation.latitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        if (_currentPosition != null) {
          ubicacion = _currentPosition.latitude.toString() +
              _currentPosition.longitude.toString();
        }
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        _getAddress(_currentPosition.latitude, _currentPosition.longitude)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add = null;
   try{
     add = 
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
   }catch(Exception){

   }
    return add;
  }
}
