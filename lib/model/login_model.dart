import 'dart:convert';
LoginResponseModel loginResponseFromJson(String str) =>
  LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel{
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;

  LoginResponseModel({this.success, this.statusCode, this.code, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    data = json['data'].length > 0 ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null){
      data['data'] = this.data.toJson();
    }
    return data;
  }

}

class Data{
  //String token;
  String IDUSUARIO;
  String USR_NOMBRES;
  String IDUSUARIOTIPO;
  String IDCODIGOGENERAL;
  String NOMBRES;
  String A_PATERNO;
  String A_MATERNO;

  Data({
    this.IDUSUARIO,
    this.USR_NOMBRES,
    this.IDUSUARIOTIPO,
    this.IDCODIGOGENERAL,
    this.NOMBRES,
    this.A_PATERNO,
    this.A_MATERNO,
  });

  Data.fromJson(Map<String, dynamic> json){
    IDUSUARIO = json['IDUSUARIO'];
    USR_NOMBRES = json['USR_NOMBRES'];
    IDUSUARIOTIPO = json['IDUSUARIOTIPO'];
    IDCODIGOGENERAL = json['IDCODIGOGENERAL'];
    NOMBRES = json['NOMBRES'];
    A_PATERNO = json['A_PATERNO'];
    A_MATERNO = json['A_MATERNO'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDUSUARIO'] = this.IDUSUARIO;
    data['USR_NOMBRES'] = this.USR_NOMBRES;
    data['IDUSUARIOTIPO'] = this.IDUSUARIOTIPO;
    data['IDCODIGOGENERAL'] = this.IDCODIGOGENERAL;
    data['NOMBRES'] = this.NOMBRES;
    data['A_PATERNO'] = this.A_PATERNO;
    data['A_MATERNO'] = this.A_MATERNO;
  }
}