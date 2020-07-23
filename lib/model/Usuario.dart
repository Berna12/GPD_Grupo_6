import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
//s

// MODELO USUARIO ACTUALMENTE NO POSEE LAS ESTRCUTURAS DE DATOS CORRECTAS
class Usuario {
  String uid;
  String nombre;
  List<String> oficios;
  String espacio;

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

  Usuario({
    this.email,
    this.uid,
    this.nombre,
    this.imagen,
    this.telefono,
  });

// METODO QUE CONVIERTE EL DOCUMENTO A UN TIPO DE OBJETO USUARIO
  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        nombre = snapshot['nombre'],
        oficios = List.from(snapshot.data['oficios']),
        espacio = snapshot['espacio'],
        educacion1 = snapshot['educacion1'],
        educacion2 = snapshot['educacion2'],
        educacion3 = snapshot['educacion3'],
        experiencia1 = snapshot['experiencia1'],
        experiencia2 = snapshot['experiencia2'],
        experiencia3 = snapshot['experiencia3'],
        anualidad1 = snapshot['anualidad1'],
        anualidad2 = snapshot['anualidad2'],
        anualidad3 = snapshot['anualidad3'],
        telefono = snapshot['telefono'],
        email = snapshot['correo'],
        pagina = snapshot['pagina'],
        ciudad = snapshot['ciudad'],
        imagen = snapshot['imagen'];
}

List<Usuario> toUsersList(QuerySnapshot query) {
  return query.documents.map((doc) => Usuario.fromSnapshot(doc)).toList();
}
