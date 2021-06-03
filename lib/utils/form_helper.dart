import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final fieldText = TextEditingController();
void clearText() {
  fieldText.clear();
}

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('dd-MM-yyyy');
//final String fechaHoy ="";

class FormHelper {
  static String fechaHoy = formatter.format(now);

  static Widget inputFieldWidget(BuildContext context, Icon icon,
      String keyName, String labelName, Function onValidate, Function onSaved,
      {String initialValue = "", obscureText: false, Widget suffixIcon}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        initialValue: initialValue,
        key: new Key(keyName),
        obscureText: obscureText,
        validator: (val) {
          return onValidate(val);
        },
        onSaved: (val) {
          return onSaved(val);
        },
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            hintText: labelName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
            )),
      ),
    );
  }

  static Widget inputDateFieldWidget(BuildContext context, Icon icon,
      String keyName, String labelName, Function onValidate, Function onSaved,
      {String initialValue = "",
      obscureText: false,
      Widget suffixIcon}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 60),
      child: TextFormField(
        enabled: false,
        initialValue: fechaHoy,
        key: new Key(keyName),
        obscureText: obscureText,
        validator: (val) {
          return onValidate(val);
        },
        onSaved: (val) {
          return onSaved(val);
        },
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            hintText: labelName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
            )),
      ),
    );
  }

  static Widget saveButton(
    String buttonText,
    Function onTap,
  ) {
    return Container(
      height: 60,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white, style: BorderStyle.solid, width: 1.0),
              color: Colors.amberAccent[700],
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: [
              new FlatButton(
                  onPressed: () {
                    return onPressed();
                  },
                  child: new Text(buttonText))
            ],
          );
        });
  }

  
}
