import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'Calificaciones.dart';
//hj

// MODELO USUARIO ACTUALMENTE NO POSEE LAS ESTRCUTURAS DE DATOS CORRECTAS
class Usuario {
  String uid;
  String nombre;
  List<String> oficios;
  String espacio;
  String tipocuenta;
  String educacion1;
  String educacion2;
  String educacion3;

  String experiencia1;
  String experiencia2;
  String experiencia3;
  String anualidad1;
  String anualidad2;
  String anualidad3;

  String telefono;

  String email;
  String imagen;
  String pagina;
  String ciudad;
  String estado;
  //CALIFICACIONES DEL USUARIO
  int puntaje;
  int totalvotos;
  double rating;
  List<Calificaciones> calificaciones;

  Usuario({
    this.email,
    this.uid,
    this.nombre,
    this.imagen,
    this.telefono,
  });

  /*    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));
 */
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "nombre": nombre,
        "oficios": List<dynamic>.from(oficios.map((x) => x)),
        "tipocuenta": tipocuenta,
        "educacion1": educacion1,
        "educacion2": educacion2,
        "educacion3": educacion3,
        "experiencia1": experiencia1,
        "experiencia2": experiencia2,
        "experiencia3": experiencia3,
        "anualidad1": anualidad1,
        "anualidad2": anualidad2,
        "anualidad3": anualidad3,
        "telefono": telefono,
        "email": email,
        "imagen": imagen,
        "pagina": pagina,
        "ciudad": ciudad,
        "estado": estado,
        "puntaje": puntaje,
        "totalvotos": totalvotos,
        "rating": rating,
        "espacio": espacio,
        "calificaciones":
            List<dynamic>.from(calificaciones.map((x) => x.toMap())),
      };

// METODO QUE CONVIERTE EL DOCUMENTO A UN TIPO DE OBJETO USUARIO
  Usuario.fromSnapshot(DocumentSnapshot docs)
      : uid = docs.documentID,
        nombre = docs['nombre'],
        puntaje = docs['puntaje'],
        totalvotos = docs['totalvotos'],
        rating = docs['rating'],
        oficios = List.from(docs.data['oficios']),
        espacio = docs['espacio'],
        educacion1 = docs['educacion1'],
        educacion2 = docs['educacion2'],
        educacion3 = docs['educacion3'],
        experiencia1 = docs['experiencia1'],
        experiencia2 = docs['experiencia2'],
        experiencia3 = docs['experiencia3'],
        anualidad1 = docs['anualidad1'],
        anualidad2 = docs['anualidad2'],
        anualidad3 = docs['anualidad3'],
        telefono = docs['telefono'],
        email = docs['correo'],
        pagina = docs['pagina'],
        tipocuenta = docs['tipocuenta'],
        ciudad = docs['ciudad'],
        estado = docs['estado'],
        calificaciones = List<Calificaciones>.from(
            docs["calificaciones"].map((x) => Calificaciones.fromMap(x))),
        imagen = docs['imagen'];
}

List<Usuario> toUsersList(QuerySnapshot query) {
  return query.documents.map((doc) => Usuario.fromSnapshot(doc)).toList();
}
