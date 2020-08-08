import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Calificaciones {
  Calificaciones({
    this.email,
    this.fecha,
    this.mensaje,
    this.puntuacion,
  });

  String email;
  String fecha;
  String mensaje;
  int puntuacion;

  factory Calificaciones.fromJson(String str) =>
      Calificaciones.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Calificaciones.fromMap(Map<String, dynamic> json) => Calificaciones(
        email: json["email"],
        fecha: json["fecha"],
        mensaje: json["mensaje"],
        puntuacion: json["puntuacion"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "fecha": fecha,
        "mensaje": mensaje,
        "puntuacion": puntuacion,
      };
}
