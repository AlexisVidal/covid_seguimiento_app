import 'package:intl/intl.dart';

class SeguimientoModel {
   int id_segumiento;
   String IDCODIGOGENERAL;
   DateTime fecha_registro;
   String ubicacion;
   String sensacion;
   String sintomas;
   String prueba_covid;
   String fecha_prueba;
   String contacto_covid;
   String trabajador;

  SeguimientoModel({
    this.id_segumiento,
    this.IDCODIGOGENERAL,
    // ignore: non_constant_identifier_names
    this.fecha_registro,
    this.ubicacion,
    this.sensacion,
    this.sintomas,
    this.prueba_covid,
    this.fecha_prueba,
    this.contacto_covid,
    this.trabajador,
  });
var dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

  SeguimientoModel.fromJson(Map<String, dynamic> json){
    id_segumiento = json['id_segumiento'];
    IDCODIGOGENERAL = json['IDCODIGOGENERAL'];
    fecha_registro = DateTime.parse(json['fecha_registro']);
    ubicacion = json['ubicacion'];
    sensacion = json['sensacion'];
    sintomas = json['sintomas'];
    prueba_covid = json['prueba_covid'];
    fecha_prueba = json['fecha_prueba'];
    contacto_covid = json['contacto_covid'];
    trabajador = json['trabajador'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_segumiento'] = this.id_segumiento;
    data['IDCODIGOGENERAL'] = this.IDCODIGOGENERAL;
    data['fecha_registro'] = this.fecha_registro;
    data['ubicacion'] = this.ubicacion;
    data['sensacion'] = this.sensacion;
    data['sintomas'] = this.sintomas;
    data['prueba_covid'] = this.prueba_covid;
    data['fecha_prueba'] = this.fecha_prueba;
    data['contacto_covid'] = this.contacto_covid;
    data['trabajador'] = this.trabajador;
  }
  
}