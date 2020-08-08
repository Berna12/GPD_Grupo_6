import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/utils/Loading.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';

import 'Perfil.dart';

class Aprobado extends StatefulWidget {
  Aprobado({this.file, this.data, this.recibo});
  Map data;
  File file;
  String recibo;
  //String query;

  @override
  _AprobadoState createState() => _AprobadoState();
}

class _AprobadoState extends State<Aprobado> {
  String url;
  bool loading = false;
  String password;
  @override
  void initState() {
    super.initState();

    print(widget.data);

    password = widget.data["contraseña"];

    saveData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //endDrawer: CustomDrawer(),
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
      ),
    );
  }

  void changeWidget() async {
    Loading().loading(context);
    try {
      await FirebaseAuth.instance // SE VALIDA SI EL USUARIO EXISTE
          .signInWithEmailAndPassword(
              email: widget.data["correo"], password: password)
          .then((currentUser) async => await Firestore.instance
                  .collection("usuarios")
                  .document(currentUser.user.uid)
                  .get()
                  .then((DocumentSnapshot result) async {
                //SE VALIDA EL TIPO DE USUARIO QUE ESTA INGRESANDO AL APP

                Usuario user = Usuario.fromSnapshot(result);
                if (user.estado == "Activada") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PerfilPage(
                                userFirebase: user,
                              )));
                } else {
                  Navigator.pop(context);
                  CustomFlush().showCustomBar(context,
                      "Tu cuenta no esta activa debes esperar a que se verifique tu informacion");
                  Timer(Duration(seconds: 2), () {
                    FirebaseAuth.instance.signOut().then((value) => {
                          Navigator.pushReplacementNamed(context, "Home"),
                        });
                  });
                }
              }))
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

        final StorageUploadTask uploadTask =
            perfilImage.child(timeKey.toString() + ".jpg").putFile(widget.file);
        var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        //AGREGAR ESE REGISTRO A LA TABLA DE USUARIOS
        url = imageUrl.toString();
        widget.data["imagen"] = url;
        widget.data["contraseña"] = "";
        //ACA DEBERIAS COLOCAR QUE LA PASSWORD EN LA BD SE BLANQUEE

        if (widget.data["tipocuenta"] != "Gratuita") {
          await sendEmail();
        }
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

        print(err);
      });
    } catch (exception) {
      Navigator.pop(context);
      CustomFlush().showCustomBar(context, exception.toString());
    }
  }

  Future<bool> sendEmail() async {
    String username = 'guiaprofecional@gmail.com';
    String password = 'gpd123456';

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address("guiaprofecional@gmail.com") //QUIEN ENVIA ? EL CORREO
      ..recipients.add(widget.data["correo"]) // quien recibe el correo.
      ..ccRecipients.addAll([
        'guiaprofecional@gmail.com',
      ])
      /*
      ..bccRecipients
          .add(Address('edugocarruci@gmail.com')) // correo del cliente */
      ..subject = 'Nuevo usuario en GPD, Recibo:  ${widget.recibo.trim()}'
      ..text =
          'Este es tu comprobante de Pago debes esperas 24Hrs para que los administradores verifiquen tu pago. \nRECIBO: ' +
              widget.recibo.trim()
      ..html =
          "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p> EL PERUCA PRIMERO";

    var connection = PersistentConnection(smtpServer);

    // enviando message
    bool bandera = await connection.send(message).then((value) async {
      return true;
    }).catchError((error) {
      print(error.toString());
      return false;
    });

    // close the connection
    await connection.close();
    return bandera;
  }
}
