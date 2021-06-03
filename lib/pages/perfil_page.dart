import 'package:covid_seguimiento_app/services/api_service.dart';
import 'package:covid_seguimiento_app/utils/custom_dialog_box.dart';
import 'package:covid_seguimiento_app/utils/form_helper.dart';
import 'package:covid_seguimiento_app/utils/variables.dart';
import 'package:covid_seguimiento_app/services/ProgressHUD.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  var empresaselected = Variables.empresa;
  var nombres = Variables.nombres;
  var apepaterno = Variables.apellidoPaterno;
  var apematerno = Variables.apellidoMaterno;
  var dni = Variables.dni;
  String _pwd = "";
  String _pwdn = "";
  bool hidePassword = true;
  bool isApiCallProcess = false;
  

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldkey,
        body: ProgressHUD(
          child: _perfilUISetup(context),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _perfilUISetup(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(key: globalFormKey, child: _perfilUI(context)),
      ),
    );
  }

  Widget _perfilUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 0, top: 20),
            child: Text(
              "Datos de trabajador",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top:0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/person.png',
                  fit: BoxFit.contain,
                  width: 110,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 1, top: 10),
            child: Text(
              "DNI",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: Text(
              dni,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 1, top: 5),
            child: Text(
              "Nombres",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: Text(
              nombres,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 1, top: 5),
            child: Text(
              "Apellido Paterno",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 1),
            child: Text(
              apepaterno,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 1, top: 5),
            child: Text(
              "Apellido Materno",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 1),
            child: Text(
              apematerno,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 1, top: 5),
            child: Text(
              "Cambio de contraseña",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: FormHelper.inputFieldWidget(
              context, Icon(Icons.lock), "password", "Contraseña actual",
              (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "Valor de contraseña no puede estar vacio";
            }
            return null;
          }, (onSavedValue) {
            _pwd = onSavedValue.toString().trim();
          },
              initialValue: "",
              obscureText: hidePassword,
              suffixIcon: IconButton(
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.amberAccent,
              )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 40, right: 40),
          child: FormHelper.inputFieldWidget(
              context, Icon(Icons.lock), "password", "Contraseña nueva",
              (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "Valor de contraseña no puede estar vacio";
            }
            return null;
          }, (onSavedValue) {
            _pwdn = onSavedValue.toString().trim();
          },
              initialValue: "",
              obscureText: hidePassword,
              suffixIcon: IconButton(
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.amberAccent,
              )),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.saveButton(
            "Actualizar",
            () {
              if (validateAndSave()) {
                print("Pass Old: $_pwd");
                print("Pass new: $_pwdn");
                setState(() {
                  this.isApiCallProcess = true;
                });

                ApiServices.updatePass(
                        Variables.username, _pwd, _pwdn, empresaselected)
                    .then((response) {
                  setState(() {
                    this.isApiCallProcess = false;
                  });
                  if (response) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: "Exito",
                          descriptions:
                              "La contraseña se actualizó correctamente!",
                          text: "OK",
                        );
                      },
                    );
                    
                    // globalFormKey.currentState.reset();
                    // Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    FormHelper.showMessage(context, "Login Error",
                        "Credenciales incorrectas!", "Ok", () {
                      Navigator.of(context).pop();
                    });
                  }
                });
              }
              return null;
            },
          ),
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
}
