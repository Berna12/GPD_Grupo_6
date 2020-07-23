/* import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/Loader.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';

import 'Perfil.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

// CAMPOS NECESARIOS PARA LA SOLICITUD DE LOS DATOS ENTRANTES
class _RegistroPageState extends State<RegistroPage> {
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // VALIDACION DEL FORMUARILIO
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; //GET ANCHO DE LA PANTALLA
    return Scaffold(
      endDrawer: CustomDrawer(),
      //drawer: CustomDrawer(),
      appBar: CustomBar(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/gpd1.png"),
                  Text("GPD", style: Utils.styleGreenTitle),
                  SizedBox(height: 15),
                  Text(
                    "Rellena tu Formulario de Registro",
                    style: Utils.styleGreenNormalText,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    controller: controllerEmail,
                    hintText: "Email Requerido",
                    inputType: TextInputType.emailAddress,
                    labelText: "Correo",
                    /*  prefixIconData: Icons.email, */
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    controller: controllerPassword,
                    hintText: "Contraseña Requerido",
                    inputType: TextInputType.text,
                    labelText: "Contraseña",
                    /*     prefixIconData: Icons.lock, */
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    controller: controllerPhone,
                    hintText: "Telefono Requerido",
                    inputType: TextInputType.number,
                    labelText: "Telefono",
                    /*   prefixIconData: Icons.phone, */
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomMaterialButton(
                    height: 45,
                    typebutton: false,
                    width: width * 0.455,
                    text: "Guardar Datos",
                    function: save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//LOADER
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

//GRABADO DE DATOS
  void save() async {
    if (_formKey.currentState.validate()) {
      // VALIDACION DE COMPLETITUD DE LOS DATOS
      loader();
      try {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: controllerEmail.text.trim(),
                password: controllerPassword.text.trim())
            .then((currentUser) => Firestore.instance
                    .collection("usuarios")
                    .document(currentUser.user.uid)
                    .setData({
                  "uid": currentUser.user.uid,
                  "nombre": "Escribe tu nombre completo aquí",
                  "espacio": "Dinos algo sobre ti en este espacio",
                  "oficios": [
                    "Primer oficio o Profesión",
                    "Segundo oficio o Profesión",
                    "Tercer oficio o Profesión",
                    "Cuarto oficio o Profesión"                                   
                  ],
                  "educacion1": "",
                  "educacion2": "",
                  "educacion3": "",
                  "experiencia1": "",
                  "experiencia2": "",
                  "experiencia3": "",
                  "anualidad1": "",
                  "anualidad2": "",
                  "anualidad3": "",
                  "correo": controllerEmail.text.trim(),
                  "telefono": controllerPhone.text.trim(),
                  "ciudad": "",
                  "pagina": "",
                  "url":
                      "https://image.freepik.com/vector-gratis/ilustracion-concepto-error-404-monstruo_114360-1879.jpg"
                }).then((result) {
                  Navigator.pop(context);

                  CustomFlush().showCustomBar(context, "Creado");
                  Timer(Duration(milliseconds: 1000), () async {
                    Navigator.pop(context);
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: controllerEmail.text.trim(),
                            password: controllerPassword.text.trim())
                        .then((currentUser) async => await Firestore.instance
                            .collection("usuarios")
                            .document(currentUser.user.uid)
                            .get()
                            .then((DocumentSnapshot result) async => ({
                                 /*  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PerfilPage(
                                                userFirebase:
                                                    Usuario.fromSnapshot(
                                                        result),
                                              ))), */
                                })));
                  });
                }).catchError((err) {
                  Navigator.pop(context);

                  CustomFlush().showCustomBar(context, err.toString());
                  Timer(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });

                  print(err);
                }))
            .catchError((err) {
          Navigator.pop(context);

          CustomFlush().showCustomBar(context, err.toString());
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          print(err);
        });
      } catch (error) {
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, error.toString());
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });

        print(error.toString());
      }
    } else {
      CustomFlush().showCustomBar(context, "Debes completar los campos");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}
 */