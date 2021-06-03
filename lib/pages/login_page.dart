import 'package:covid_seguimiento_app/model/empresa_model.dart';
import 'package:covid_seguimiento_app/services/ProgressHUD.dart';
import 'package:covid_seguimiento_app/services/api_service.dart';
import 'package:covid_seguimiento_app/utils/custom_dialog_box.dart';
import 'package:covid_seguimiento_app/utils/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../utils/form_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String empresaselected = "VILOCRU SAC";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String _username = "";
  String _pwd = "";
  bool hidePassword = true;
  bool isApiCallProcess = false;

  final List<EmpresaModel> _empresaModelList = [
    EmpresaModel(nombreEmpresa: 'VILOCRU SAC', idEmpresa: 1),
    EmpresaModel(nombreEmpresa: 'CORP. CRUZ SAC', idEmpresa: 2),
  ];
  EmpresaModel _empresaModel = EmpresaModel();
  List<DropdownMenuItem<EmpresaModel>> _empresaModelDropdownList;
  List<DropdownMenuItem<EmpresaModel>> _buildEmpresaModelDropdown(
      List empresaModelList) {
    List<DropdownMenuItem<EmpresaModel>> items = List();
    for (EmpresaModel _empresaModel in empresaModelList) {
      items.add(DropdownMenuItem(
        value: _empresaModel,
        child: Text(_empresaModel.nombreEmpresa),
      ));
    }
    return items;
  }

  _onChangeEmpresaModelDropdown(EmpresaModel empresaModel) {
    setState(() {
      _empresaModel = empresaModel;
      empresaselected = _empresaModel.nombreEmpresa;
      String pass = "221084";
      String encoded = base64.encode(utf8.encode(pass));

      print('encoded: $encoded');
    });
  }

  @override
  void initState() {
    _empresaModelDropdownList = _buildEmpresaModelDropdown(_empresaModelList);
    _empresaModel = _empresaModelList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldkey,
        body: ProgressHUD(
          child: _loginUISetup(context),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _loginUISetup(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(key: globalFormKey, child: _loginUI(context)),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.amberAccent[100], Colors.amberAccent]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logos.png',
                  fit: BoxFit.contain,
                  width: 280,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Center(
          child: Padding(
              padding: EdgeInsets.only(bottom: 20, top: 40),
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, top: 20, left: 20, right: 20),
          child: CustomDropdown(
            dropdownMenuItemList: _empresaModelDropdownList,
            onChanged: _onChangeEmpresaModelDropdown,
            value: _empresaModel,
            isEnabled: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.verified_user),
            "username",
            "Usuario",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
              return "Valor de usuario no puede estar vacio";
              }
              return null;
            },
            (onSavedValue) {
              _username = onSavedValue.toString().trim();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          child: FormHelper.inputFieldWidget(
              context, Icon(Icons.lock), "password", "Contraseña",
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
        SizedBox(
          height: 20,
        ),
        new Center(
          child: FormHelper.saveButton(
            "Login",
            () {
              if (validateAndSave()) {
                print("Username: $_username");
                print("Password: $_pwd");
                setState(() {
                  this.isApiCallProcess = true;
                });

                ApiServices.loginEmpleado(_username, _pwd, empresaselected).then((response) {
                  setState(() {
                    this.isApiCallProcess = false;
                  });
                  if(response){
                    globalFormKey.currentState.reset();
                    Navigator.of(context).pushReplacementNamed('/home');
                  }else{
                    // FormHelper.showMessage(context, "Login Error", "Credenciales incorrectas!", "Ok", (){
                    //   Navigator.of(context).pop();
                    // });
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: "Error",
                          descriptions:
                              "Credenciales incorrectas! o  no se puede conectar con el servidor!",
                          text: "OK",
                        );
                      },
                    );
                  }
                });
              }
              return null;
            },
          ),
        )
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
