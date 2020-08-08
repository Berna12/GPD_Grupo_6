import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


// MODULO / CLASE  / OBJETO QUE CONTENDRA EL MAPA DE LOS ULTIMAS BUSQUEDAS


class Busquedas {
  List<Parametro> parametros; //COMPROBAR EL MAP DE LIST DE PARAMETROS
  String uid;
  Busquedas({
    this.parametros,
    this.uid,
  });

  factory Busquedas.fromJson(String str) => Busquedas.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Busquedas.fromMap(DocumentSnapshot docs) => Busquedas(
  
        parametros: List<Parametro>.from(
            docs["parametros"].map((x) => Parametro.fromMap(x))),
            uid:docs['uid'],

      );

  Map<String, dynamic> toMap() => {
        "parametros": List<dynamic>.from(parametros.map((x) => x.toMap())),
      };
}
// RECORDAR QUE SON MAPAS
class Parametro {
  Parametro({
    this.oficio,
    this.fecha,
  });

  String oficio;
  String fecha;

  factory Parametro.fromJson(String str) => Parametro.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Parametro.fromMap(Map<String, dynamic> json) => Parametro(
        oficio: json["oficio"],
        fecha: json["fecha"],
      );

  Map<String, dynamic> toMap() => {
        "oficio": oficio,
        "fecha": fecha,
      };
}
