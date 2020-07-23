import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/Loader.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';

import 'Perfil.dart';

class Aprobado extends StatefulWidget {
  Aprobado({this.file, this.data});
  Map data;
  File file;

  @override
  _AprobadoState createState() => _AprobadoState();
}

class _AprobadoState extends State<Aprobado> {
  String url;
  bool loading = false;
  String password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.data["correo"]);
    print(widget.data["contraseña"]);
    print(widget.data["imagen"]);
    password = widget.data["contraseña"];
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: CustomDrawer(),
      //drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Utils.colorgreen,
        leading: Container(),
      ),

      body: SingleChildScrollView(
        child: Container(
          height: height * 0.90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Perfil Creado Exitosamente",
                style: Utils.styleGreenTitleNormal,
              ),
              Icon(
                Icons.assignment_turned_in,
                size: 200,
                color: Colors.green,
              ),
              Text(
                "Te estaremos enviando un correo para" +
                    " activar tu cuenta. Y el caso de que hayas registrado un numero " +
                    "también lo recibiras via mensaje.",
                style: TextStyle(color: Utils.colorgreen),
                textAlign: TextAlign.center,
              ),
              Text(
                "Si el pago fue mediante deposito bancario, permítenos 24 horas para validar el pago " +
                    "el pago antes de que recibas el correo.",
                style: TextStyle(color: Utils.colorgreen),
                textAlign: TextAlign.center,
              ),
              if (loading) ...[
                CustomMaterialButton(
                  height: 40,
                  typebutton: false,
                  width: width * 0.45,
                  text: "Continuar",
                  function: changeWidget,
                ),
              ] else if (!loading) ...[
                CircularProgressIndicator(
                  backgroundColor: Utils.colorgreen,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  void changeWidget() async {
    loader();
    try {
      await FirebaseAuth.instance // SE VALIDA SI EL USUARIO EXISTE
          .signInWithEmailAndPassword(
              email: widget.data["correo"], password: password)
          .then((currentUser) async => await Firestore.instance
              .collection("usuarios")
              .document(currentUser.user.uid)
              .get()
              .then((DocumentSnapshot result) async => ({
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerfilPage(
                                  userFirebase: Usuario.fromSnapshot(
                                      result), // SE REALIZA EL DESMAPEO DEL DOCUMENTO.
                                ))),
                  })))
          .catchError((error) {
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, error.toString());
        Timer(Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }).catchError((err) {
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, err.toString());
        Timer(Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      });
    } on PlatformException catch (e) {
      Navigator.pop(context);
      CustomFlush().showCustomBar(context, e.toString());
      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }
  }

  Future<bool> loader() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ColorLoader3(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void saveData() async {
    //loader();
    try {
      //OBJETIVO CREAR EL USUARIO FORMATEAR LA HORA Y FECHA PARA ASIGNARLO COMO NOMBRE A LA FOTO
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.data["correo"], password: widget.data["contraseña"])
          .then((currentUser) async {
        widget.data["imagen"] = "";
        var timeKey = DateTime.now();
        var formatDate = DateFormat('MMM d, yyyy');
        var formatTime = DateFormat('EEEE , hh:mm aaa');

        String date = formatDate.format(timeKey);
        String time = formatDate.format(timeKey);

        final StorageReference perfilImage =
            FirebaseStorage.instance.ref().child("Fotos");

        final StorageUploadTask uploadTask = perfilImage
            .child(timeKey.toString() + ".jpg")
            .putFile(widget.file); 
        var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        //AGREGAR ESE REGISTRO A LA TABLA DE USUARIOS
        url = imageUrl.toString();
        widget.data["imagen"] = url;
        widget.data["contraseña"] = "";
        //ACA DEBERIAS COLOCAR QUE LA PASSWORD EN LA BD SE BLANQUEE
        Firestore.instance
            .collection("usuarios")
            .document(currentUser.user.uid)
            .setData(widget.data)
            .then((value) {
          // ACA DEBERIA ESTAR EL LOGUEOO DEL CLIENTE.
          loading = true;
          setState(() {});
        });
      }).catchError((err) {
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, err.toString());
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });

        print(err);
      });
    } catch (exception) {
      Navigator.pop(context);
      CustomFlush().showCustomBar(context, exception.toString());
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

/*     Firestore.instance
        .collection("usuarios")
        .document(widget.userFirebase.uid)
        .updateData(data)
        .then((_) => {
              Firestore.instance
                  .collection("usuarios")
                  .document(widget.userFirebase.uid)
                  .get()
                  .then((DocumentSnapshot result) async {
                widget.userFirebase = Usuario.fromSnapshot(result);
                Navigator.pushNamed(context, "Home");
              }),
            }); */

}
