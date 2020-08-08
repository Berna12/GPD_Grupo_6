import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rep_gpd_work/model/Busquedas.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/DetailPerfil.dart';
import 'package:rep_gpd_work/src/pages/ReportarUsuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';

class ContainerPersons extends StatefulWidget {
  List<Usuario> items;
  Usuario userFirebase;
  String controller;

  ContainerPersons({this.items, this.userFirebase, this.controller});
  @override
  _ContainerPersonsState createState() => _ContainerPersonsState();
}

class _ContainerPersonsState extends State<ContainerPersons> {
  final format = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();

    print(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: index % 2 == 0
                          ? Colors.black.withOpacity(0.25)
                          : Utils.colorgreen.withOpacity(0.25),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              width: width,
              height: 120,
              //color: Colors.red,
              child: Row(
                children: <Widget>[
                  Container(
               
                    width: 150,
                    height: 120,
                     //color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipOval(
                        child: Image.network(
                          widget.items[index].imagen,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //  color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.only(top:3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.items[index].nombre,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          
                            Row(
                              children: <Widget>[
                                Text(widget.items[index].rating.toString()),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellowAccent[700],
                                )
                              ],
                            ),
                           
                            Container(
                              height: 35,
                              child: Text(widget.items[index].espacio,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontSize: 14)),
                            ),
                           
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    print(widget.controller);
                                    await sendData();
                                    print(widget.userFirebase);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPerfil(
                                                  dataperfil:
                                                      widget.items[index],
                                                  userFirebase:
                                                      widget.userFirebase,
                                                )));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: width * 0.18,
                                      color: Utils.colorgreen,
                                      child: Text(
                                        "Abrir",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print(widget.controller);
                                    await sendData();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Reportar(
                                                  report: widget.items[index],
                                                  userFirebase:
                                                      widget.userFirebase,
                                                )));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                                                        child: Container(
                                      color: Colors.green,
                                      width: width * 0.25,
                                      height: 30,
                                      alignment: Alignment.center,
                                      child: Text("Denunciar"),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> sendData() async {
    print("DATA " + widget.controller);
    var date = new DateTime.now(); //  TOMAR LA FECHA DEL DIA

    //APILAR LOS ELEMENTOS DE LA COLA
    QuerySnapshot snapshot = await Firestore.instance
        .collection('busquedas')
        .getDocuments(); // SE SELECCIONA LOS DOCUMENTOS

    Busquedas items = Busquedas.fromMap(
        snapshot.documents[0]); // SE BUSCA PARSEAR LOS REGISTROS ES UNA LISTA
    Parametro parametro = new Parametro();
    parametro.fecha = format.format(
        DateTime.parse(date.toString())); // SE PARSEA LA FECHA AL FROMATO

    parametro.oficio = widget.controller.trim();
    //AGREGAR NUEVO ELEMENTO AL FINAL Y EMPUJAR LOS SIGUIENTES ELEMENTOS
    items.parametros[3] = items.parametros[2]; // SE ENCOLA EN LA PILA
    items.parametros[2] = items.parametros[1];
    items.parametros[1] = items.parametros[0];
    items.parametros[0] = parametro;

    Map data = items.toMap(); // SE SETEA EL MAPA
    Firestore.instance
        .collection("busquedas")
        .document(items.uid)
        .updateData(data) // se actualiza el registr
        .then((value) => ({print("SUCCESS!!!! ")}));
  }
}
